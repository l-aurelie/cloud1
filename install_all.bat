set NGINX_SERV_IP=192.168.1.29
set PHP_SERV_IP=192.168.1.27
set MYSQL_SERV_IP=192.168.1.28

set NGINX_USR=aurelie
set PHP_USR=aurelie
set MYSQL_USR=aurelie

::INSTALL SSH ,  TODO : NEEDS TO  LOOKS HOW TO SECURE ON WINDOWS  
::powershell.exe -Command "Add-WindowsCapability -Online -Name OpenSSH.Client"
::powershell.exe -Command "Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0"
::powershell.exe -Command "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0"
::powershell.exe -Command "Start-Service sshd"

:: OPTIONAL but recommended: what is it for ? 
::Set-Service -Name sshd -StartupType 'Automatic'

::TODO
:: Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
::powershell.exe -Command "if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
::    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
::    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
::} else {
::    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
::}"

::ssh-keygen
::TODO
::ssh-copy-id %NGINX_USR%@%NGINX_SERV_IP%
::ssh-copy-id %PHP_USR%@%PHP_WDP_SERV_IP%
::ssh-copy-id %MYSQL_USR%@%MYSQL_SERV_IP%

:: MYSQL
::scp mysql_install.sh secret.sh machines_deps.sh %MYSQL_USR%@%MYSQL_SERV_IP%:/home/%MYSQL_USR%/
::ssh -t %MYSQL_USR%@%MYSQL_SERV_IP% "dos2unix mysql_install.sh machines_deps.sh secret.sh; chmod 755 ./mysql_install.sh ./machines_deps.sh; ./mysql_install.sh"

::PHP
::scp remote_mysql.sh machines_deps.sh %PHP_USR%@%PHP_SERV_IP%:/home/%PHP_USR%/
::ssh -t %PHP_USR%@%PHP_SERV_IP% "dos2unix remote_mysql.sh machines_deps.sh; chmod 755  ./remote_mysql.sh ./machines_deps.sh ; ./remote_mysql.sh"

::NGINX
scp machines_deps.sh nginx_install.sh %NGINX_USR%@%NGINX_SERV_IP%:/home/%NGINX_USR%/
ssh -t %NGINX_USR%@%NGINX_SERV_IP% "dos2unix nginx_install.sh machines_deps.sh; chmod 755  ./nginx_install.sh ./machines_deps.sh ; ./machines_deps.sh ; ./nginx_install.sh"