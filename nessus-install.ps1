#To run this Powershell script, make sure you run: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
#Put your Tenable.io linking key here
$LINKINGKEY="--------Your Tenable.io Linking Key Goes here---------------"

#Pick 64-bit or 32-bit Nessus installer variables
#For 64-bit Nessus
$NESSUSINSTALLER="Nessus-8.5.1-x64.msi"
$NESSUSTITLE="Tenable Nessus (x64) - InstallShield Wizard"

#For 32-bit Nessus
$NESSUSINSTALLER="Nessus-8.5.1-win32.msi"
$NESSUSTITLE="Tenable Nessus - InstallShield Wizard"


#Additional requirements, the winpcap_4_1_3.exe and 
# the Nessus installer file in the local directory.

#Make sure WinPcap and Nessus are not already installed otherwise this script will fail.

#Get rid of any existing Nessus data that might cause the installer to ask about it
Remove-Item -Recurse -Force c:\programdata\tenable\nessus
Remove-Item -Recurse -Force "c:\program files\tenable\nessus"

#Next install WinPCap since it is required by Nessus
.\winpcap_4_1_3.exe
#Wait for WinPCap installer to start 
$wpcshell = New-Object -ComObject wscript.shell;
$wpcshell.AppActivate('WinPcap 4.1.3 Setup')
sleep 1

#Click Next and wait
$wpcshell.SendKeys("%N")
sleep 1

#Agree to the terms
$wpcshell.SendKeys("%A")
sleep 1

#Start the install and wait 30 seconds for it to finish
$wpcshell.SendKeys("%I")
sleep 15

$wpcshell.SendKeys("%F")
#Finished
sleep 5

#Start the installer and wait for it to run
msiexec.exe /i $NESSUSINSTALLER /L*v! nessus-msi.log
sleep 5

#Get focus on the installer
$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate($NESSUSTITLE)
Sleep 1

#Click Next and wait
$wshell.SendKeys("n")
sleep 1

#Click "I Accept" and click Next and wait
$wshell.SendKeys("%a")
$wshell.SendKeys("n")
sleep 1

#Click Next to accep the default install location and wait
$wshell.SendKeys("n")
sleep 1

#Click Install button and wait for install to finish
$wshell.SendKeys("i")
sleep 30

$wshell.SendKeys("F")
#Finished!

cd "\Program Files\Tenable\Nessus"
.\nessuscli.exe managed link --key=$LINKINGKEY --cloud
