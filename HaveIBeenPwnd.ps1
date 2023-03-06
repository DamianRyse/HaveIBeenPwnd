# Kinda simple PowerShell Script that performs a password check on PwnedPasswords.com.
# March 06, 2023 - Damian Ryse (https://github.com/DamianRyse)
# Requires PowerShell 7!!

# Get the password from the user
$usrInput = Read-Host -Prompt "Enter the password you want to check" -AsSecureString

# Calculate the SHA-1 value for the password.
# PowerShell doesn't have a built-in function to calculate the SHA-1 out of a string,
# So that's why we're using a MemoryStream instead
# See https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash?view=powershell-7.3
$stringAsStream = [System.IO.MemoryStream]::new()
$writer = [System.IO.StreamWriter]::new($stringAsStream)
$writer.write((ConvertFrom-SecureString -SecureString $usrInput -AsPlainText))
$writer.Flush()
$stringAsStream.Position = 0
$pwHash = Get-FileHash -InputStream $stringAsStream -Algorithm SHA1 | Select-Object Hash

# Display the calculated SHA-1 hash to the user
Write-Host "SHA-1 hash is: $($pwHash.Hash)"

# Get the first 5 letters, because that's enough for the API.
$initialLetters = $pwHash.Hash.Substring(0,5)

# Get the response from the server, split it into an array, remove the empty lines and add the first five letters again to each line
# because they are not part of the response.
$hashes = (Invoke-WebRequest "https://api.pwnedpasswords.com/range/$initialLetters" -UseBasicParsing).Content
$hashArray = $hashes.Split([Environment]::NewLine).Where({ $_ -ne "" }) | ForEach-Object { $_.split(":")[0] } | ForEach-Object {"$initialLetters$_"}

# Display some more interesting information
Write-Host "There are $($hashArray.Count) hashes starting with $initialLetters"

# Check now if the array contains the users pasword hash.
if ($hashArray -contains $pwHash.Hash.ToUpper()) {
    Write-Host "You have been pwned!" -ForegroundColor Black -BackgroundColor Red
}
else {
    Write-Host "All good. Nothing found." -ForegroundColor White -BackgroundColor Green
}
