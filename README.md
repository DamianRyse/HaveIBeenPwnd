# HaveIBeenPwnd
[![Support Server](https://img.shields.io/discord/409050120894545920?color=%23ef5600&label=DISCORD&style=for-the-badge)](https://discord.gg/YP4eNUF)

This is a simple PowerShell script that uses the API by [haveibeenpwned.com](https://haveibeenpwned.com/) to determine if your password has been leaked somewhere on the internet.
The script and the service do not send your password anywhere. A SHA-1 hash will be calculated out of your password and only the first 5 letters and numbers of that hash are being send to the API endpoint. The script then receives a list of all password hashes that also starts with those five characters. 
If your complete password hash is in this list, you'll see a text "You have been pwned!". If not, "All good, nothing found." appears.

## Prerequisites
- [PowerShell 7](https://github.com/PowerShell/PowerShell/releases)

## Screenshots
![](https://i.imgur.com/Vc2YKWh.png)

![](https://i.imgur.com/nmqO98V.png)

## Copyright
Feel free to copy, modify and distribute the script as you like! If you like my script, I'd be glad to be mentioned in your clone.
