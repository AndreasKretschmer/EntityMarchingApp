$containerName = 'entitymatching'
$password = '#########'
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -type 'Sandbox' -country 'de' -select 'Latest'
New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -imageName 'mybcimage' `
    -multitenant:$false `
    -includeTestToolkit `
    -includeTestLibrariesOnly `
    -includePerformanceToolkit `
    -dns '8.8.8.8' `
    -updateHosts