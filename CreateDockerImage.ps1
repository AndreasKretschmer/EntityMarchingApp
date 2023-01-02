install-module bccontainerhelper -Force
Get-InstalledModule

$containerName = 'entitymatching'
$password = 'P@ssw0rd'
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -type 'Sandbox' -country 'de' -select 'Latest'
$licenseFile = 'C:\Users\KRAN\Desktop\5306956.bclicense'
New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -imageName 'entitymatching' `
    -licenseFile $licenseFile ``
    -memoryLimit 8G