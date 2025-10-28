<#
.SYNOPSIS
    Creates a self-signed ssl cert, imports to local machine personal certs, imports to current user
    trusted root, and exports pfx to current directory
.PARAMETER Paths
  The folder path(s) to convert.
.INPUTS
  System.String[]
.OUTPUTS
  A log detailing actions taken.
#>
function New-SelfSignedPfx {
    param (
        [Parameter(Mandatory=$true)][string]$DnsName,
        [Parameter(Mandatory=$true)][string]$Password
     )
    
    # setup certificate properties including the commonName (DnsName) property for Chrome 58+
    $certificate = New-SelfSignedCertificate `
        -Subject "*.$DnsName" `
        -DnsName $DnsName, "*.$DnsName" `
        -KeyAlgorithm RSA `
        -KeyLength 2048 `
        -NotBefore (Get-Date) `
        -NotAfter (Get-Date).AddYears(2) `
        -CertStoreLocation "cert:CurrentUser\My" `
        -FriendlyName "*.$DnsName Self-Signed Certificate" `
        -HashAlgorithm SHA256 `
        -KeyUsage DigitalSignature, KeyEncipherment, DataEncipherment `
        -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.1") 
    $certificatePath = 'Cert:\CurrentUser\My\' + ($certificate.ThumbPrint)  
    
    $tmpPath = $(Get-Location).Path 
    
    # set certificate Password here
    $pfxPassword = ConvertTo-SecureString -String $Password -Force -AsPlainText
    $pfxFilePath = "$tmpPath\$DnsName.pfx"
    $cerFilePath = "$tmpPath\$DnsName.cer"
    
    # create pfx certificate
    Export-PfxCertificate -Cert $certificatePath -FilePath $pfxFilePath -Password $pfxPassword
    Export-Certificate -Cert $certificatePath -FilePath $cerFilePath
    
    # import the pfx certificate
    Import-PfxCertificate -FilePath $pfxFilePath Cert:\LocalMachine\My -Password $pfxPassword -Exportable
    
    # trust the certificate by importing the pfx certificate into your trusted root
    Import-Certificate -FilePath $cerFilePath -CertStoreLocation Cert:\CurrentUser\Root
    
    # optionally delete the physical certificates (don’t delete the pfx file as you need to copy this to your app directory)
    # Remove-Item $pfxFilePath
    Remove-Item $cerFilePath
} 

Export-ModuleMember -Function * -Alias *