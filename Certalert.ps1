#@iditbnaya
<#this script is a PS script running in jenkins when $srvPassword and SrvUser are imported in the Bindings
  This Job will send an email when a certificate is about to be expired in 30 days
  Note - In order to see the certificate it needs to be installed in the HMC-Safes Server under - MMC-certificate-computer-personal
  
#> 

$SrvPassword = ConvertTo-SecureString "$($ENV:SrvPassword)" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ("$ENV:SrvUser", $SrvPassword)


Invoke-Command -ComputerName <Server.domain> -Credential $Credential -ScriptBlock{
  
$certs = Get-childitem cert:LocalMachine -recurse -ExpiringInDays 30 |select Subject,FriendlyName,NotAfter,Thumbprint
$certs | Export-Csv c:\temp\CertExpireSoon.csv -NoTypeInformation

$smtpServer = "<smtp server>"
$smtpFrom = "CertManage@bnaya.com"
$smtpTo = "iditbnaya@bnaya.com"
$messageSubject = "Certificate about to expire "

Send-MailMessage -To $smtpTo -From $smtpfrom -SmtpServer $smtpServer -Subject $messageSubject -Attachments c:\temp\CertExpireSoon.csv
  
}


                
