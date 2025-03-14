﻿#
# This script just calls the Add-AppDevPackage.ps1 script that lives next to it.
#

param(
    [switch]$Force = $false,
    [switch]$SkipLoggingTelemetry = $false
)

$scriptArgs = ""
if ($Force)
{
    $scriptArgs = '-Force'
}

if ($SkipLoggingTelemetry)
{
    if ($Force)
    {
        $scriptArgs += ' '
    }

    $scriptArgs += '-SkipLoggingTelemetry'
}

try
{
    # Log telemetry data regarding the use of the script if possible.
    # There are three ways that this can be disabled:
    #   1. If the "TelemetryDependencies" folder isn't present.  This can be excluded at build time by setting the MSBuild property AppxLogTelemetryFromSideloadingScript to false
    #   2. If the SkipLoggingTelemetry switch is passed to this script.
    #   3. If Visual Studio telemetry is disabled via the registry.
    $TelemetryAssembliesFolder = (Join-Path $PSScriptRoot "TelemetryDependencies")
    if (!$SkipLoggingTelemetry -And (Test-Path $TelemetryAssembliesFolder))
    {
        $job = Start-Job -FilePath (Join-Path $TelemetryAssembliesFolder "LogSideloadingTelemetry.ps1") -ArgumentList $TelemetryAssembliesFolder, "VS/DesignTools/SideLoadingScript/Install", $null, $null
        Wait-Job -Job $job -Timeout 60 | Out-Null
    }
}
catch
{
    # Ignore telemetry errors
}

$currLocation = Get-Location
Set-Location $PSScriptRoot
Invoke-Expression ".\Add-AppDevPackage.ps1 $scriptArgs"
Set-Location $currLocation
# SIG # Begin signature block
# MIImHgYJKoZIhvcNAQcCoIImDzCCJgsCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCC7kxV/l3biwCGH
# VuAKUAkPVeCZ2LSQIMJf+ROzV3B37KCCC2cwggTvMIID16ADAgECAhMzAAAFp7iP
# +5ddNYTsAAAAAAWnMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTAwHhcNMjQwODIyMTkyNTU3WhcNMjUwNzA1MTkyNTU3WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQCWGlTKjYt60rB8oNyPWJUGQV2NGwlRXKJg3484q2nJiv9+Frz96fGoXlblIeJ3
# xqQxEoCEDYjjbYClgx31MZcoRqJD0sKjNtYDKA0NiSdOJQut3+HN0rSx74yqobDB
# P8AKAyWANZitUQHnPH1EkTXMdRlnJnD1RtFljMYOJnrxfqrAdtNNxU1pIYYmY6oD
# 8dye81i9RHxSJGEgfMnEIpn/1ySkikTV+NOHFj1QH7+SHZWYNcdgL48QSa1jC30A
# i6MKLh91FOsCsuNU0cTC6z6QkP51l9dU8B+xnvZa2/WzvJhByZnjXS+tVeN2KB5E
# p0seOtuFwvI6KoOXrETKCDg7AgMBAAGjggFuMIIBajAfBgNVHSUEGDAWBgorBgEE
# AYI3PQYBBggrBgEFBQcDAzAdBgNVHQ4EFgQUUhW6zVNwhzmLbscozYppwd8fKxIw
# RQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEW
# MBQGA1UEBRMNMjMwODY1KzUwMjcwMzAfBgNVHSMEGDAWgBTm/F97uyIAWORyTrX0
# IXQjMubvrDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5j
# b20vcGtpL2NybC9wcm9kdWN0cy9NaWNDb2RTaWdQQ0FfMjAxMC0wNy0wNi5jcmww
# WgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29m
# dC5jb20vcGtpL2NlcnRzL01pY0NvZFNpZ1BDQV8yMDEwLTA3LTA2LmNydDAMBgNV
# HRMBAf8EAjAAMA0GCSqGSIb3DQEBCwUAA4IBAQAl1cQIQ+FD/ubaWIiMg8wQtEx3
# SksQ5r6qAgferOe6TZ5bmTcMj2VUkHLrvmhScoRe9pQ/CqwZ676YuM90tiqPrMDj
# XO8kLCA+kTeDZoKQL0MI2ShbDhXrDIsui9hGNhd8PwGTWQksnoO4HxqGG2Mfiqsn
# OgMo9HimmTF2/H1XLc/g2TPpF8GyXAco7khch4l1hIIpmVEZN6ZFCk2/kOf7m2sC
# l8h5+BWQDmSaECtI2xc5SLbqot1isWvFiERtaw9xQb31MWYas2l2/XdcbH7QFYpK
# pG4dDZhKIdlRVmYpUyRaNOZWNwNc7G6bzKIC3HAGFOIEc4aDQu2yT/q0yJ7WMIIG
# cDCCBFigAwIBAgIKYQxSTAAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0
# IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMTAwNzA2MjA0MDE3
# WhcNMjUwNzA2MjA1MDE3WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDEw
# MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6Q5kUHlntcTj/QkATJ6U
# rPdWaOpE2M/FWE+ppXZ8bUW60zmStKQe+fllguQX0o/9RJwI6GWTzixVhL99COMu
# K6hBKxi3oktuSUxrFQfe0dLCiR5xlM21f0u0rwjYzIjWaxeUOpPOJj/s5v40mFfV
# HV1J9rIqLtWFu1k/+JC0K4N0yiuzO0bj8EZJwRdmVMkcvR3EVWJXcvhnuSUgNN5d
# pqWVXqsogM3Vsp7lA7Vj07IUyMHIiiYKWX8H7P8O7YASNUwSpr5SW/Wm2uCLC0h3
# 1oVH1RC5xuiq7otqLQVcYMa0KlucIxxfReMaFB5vN8sZM4BqiU2jamZjeJPVMM+V
# HwIDAQABo4IB4zCCAd8wEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFOb8X3u7
# IgBY5HJOtfQhdCMy5u+sMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjR
# PZSQW9fOmhjEMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNy
# bDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWljcm9z
# b2Z0LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3J0MIGd
# BgNVHSAEgZUwgZIwgY8GCSsGAQQBgjcuAzCBgTA9BggrBgEFBQcCARYxaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL1BLSS9kb2NzL0NQUy9kZWZhdWx0Lmh0bTBABggr
# BgEFBQcCAjA0HjIgHQBMAGUAZwBhAGwAXwBQAG8AbABpAGMAeQBfAFMAdABhAHQA
# ZQBtAGUAbgB0AC4gHTANBgkqhkiG9w0BAQsFAAOCAgEAGnTvV08pe8QWhXi4UNMi
# /AmdrIKX+DT/KiyXlRLl5L/Pv5PI4zSp24G43B4AvtI1b6/lf3mVd+UC1PHr2M1O
# HhthosJaIxrwjKhiUUVnCOM/PB6T+DCFF8g5QKbXDrMhKeWloWmMIpPMdJjnoUdD
# 8lOswA8waX/+0iUgbW9h098H1dlyACxphnY9UdumOUjJN2FtB91TGcun1mHCv+KD
# qw/ga5uV1n0oUbCJSlGkmmzItx9KGg5pqdfcwX7RSXCqtq27ckdjF/qm1qKmhuyo
# EESbY7ayaYkGx0aGehg/6MUdIdV7+QIjLcVBy78dTMgW77Gcf/wiS0mKbhXjpn92
# W9FTeZGFndXS2z1zNfM8rlSyUkdqwKoTldKOEdqZZ14yjPs3hdHcdYWch8ZaV4XC
# v90Nj4ybLeu07s8n07VeafqkFgQBpyRnc89NT7beBVaXevfpUk30dwVPhcbYC/GO
# 7UIJ0Q124yNWeCImNr7KsYxuqh3khdpHM2KPpMmRM19xHkCvmGXJIuhCISWKHC1g
# 2TeJQYkqFg/XYTyUaGBS79ZHmaCAQO4VgXc+nOBTGBpQHTiVmx5mMxMnORd4hzbO
# TsNfsvU9R1O24OXbC2E9KteSLM43Wj5AQjGkHxAIwlacvyRdUQKdannSF9PawZSO
# B3slcUSrBmrm1MbfI5qWdcUxghoNMIIaCQIBATCBlTB+MQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQgQ29kZSBT
# aWduaW5nIFBDQSAyMDEwAhMzAAAFp7iP+5ddNYTsAAAAAAWnMA0GCWCGSAFlAwQC
# AQUAoIGuMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsx
# DjAMBgorBgEEAYI3AgEVMC8GCSqGSIb3DQEJBDEiBCC55sfwy7JnuBF0jRtZGRnr
# FzHJ1nC8iR8tv9OzWMo65TBCBgorBgEEAYI3AgEMMTQwMqAUgBIATQBpAGMAcgBv
# AHMAbwBmAHShGoAYaHR0cDovL3d3dy5taWNyb3NvZnQuY29tMA0GCSqGSIb3DQEB
# AQUABIIBAG3AbKjslBWWMy4FzkCB5LNm6jXShF6Xymd4nKWe2XZ7Zf/yGyQcy6i0
# yA42g+4fOho5hI1CUWmnzISiKyknRUO58ImGAi7KMbk1n9oz+i4T5AonGZ4rIV6C
# VFQ62liwAGEbLgCp74MCG92jB3OQVl8B4LS/MdN7j746C/H3H/LG3wLjluTL6Bbe
# HNZbo3FSR5IgoluiFaghkdIiYd3I5cOl3rRxkoKC6zd+KseszCQnhvNd+WORcLb2
# bmUz3gP+tW1/8dUVJcuqs3cR/MKcFk5vmz4hVJy6fwAXU+JmwNshFEnqY8tM/CoC
# FHtRVmx8vithZ793Y8JLNvEdnML2/uChgheXMIIXkwYKKwYBBAGCNwMDATGCF4Mw
# ghd/BgkqhkiG9w0BBwKgghdwMIIXbAIBAzEPMA0GCWCGSAFlAwQCAQUAMIIBUgYL
# KoZIhvcNAQkQAQSgggFBBIIBPTCCATkCAQEGCisGAQQBhFkKAwEwMTANBglghkgB
# ZQMEAgEFAAQguH3cx4CToWtR9iH+vpLvbUfeBkJie3aoion7hjd2bwECBmcafvmC
# jBgTMjAyNDExMDYyMjA1MzYuNDQ3WjAEgAIB9KCB0aSBzjCByzELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFt
# ZXJpY2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjg2MDMt
# MDVFMC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNl
# oIIR7TCCByAwggUIoAMCAQICEzMAAAHxs0X1J+jAFtYAAQAAAfEwDQYJKoZIhvcN
# AQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
# BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQG
# A1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcNMjMxMjA2MTg0
# NTU1WhcNMjUwMzA1MTg0NTU1WjCByzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9u
# czEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjg2MDMtMDVFMC1EOTQ3MSUwIwYD
# VQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIICIjANBgkqhkiG9w0B
# AQEFAAOCAg8AMIICCgKCAgEAsbpQmbbSH/F/e61vfyfkOFYPT4roAdcmtfw0ccS1
# tocMuEILVN4+X1e+WSmul000IVuQpZBpeoKdZ3eVQbMeCW/qFOD7DANn6HvID/W0
# DT1cSBzCbuk2HK659/R3XXrdsZHalIc88kl2jxahTJNlYnxH4/h0eiYXjbNiy85v
# BQyZvqQXXTwy2oP0fgDyFh8n7avYrcDNFj+WdHX0MiOFpVXlEvr6LbD21pvkSrB+
# BUDYc29Lfw+IrrXHwit/yyvsS5kunZgIewDCrhFJfItpHVgQ0XHPiVmttUgnn8eU
# j4SRBYGIXRjwKKdxtZfE993Kq2y7XBSasMOE0ImIgpHcrAnJyBdGakjQB3HyPUgL
# 94H5MsakDSSd7E7IORj0RfeZqoG30G5BZ1Ne4mG0SDyasIEi4cgfN92Q4Js8Wypi
# ZnQ2m280tMhoZ4B2uvoMFWjlKnB3/cOpMMTKPjqht0GSHMHecBxArOawCWejyMhT
# OwHdoUVBR0U4t+dyO1eMRIGBrmW+qhcej3+OIuwI126bVKJQ3Fc2BHYC0ElorhWo
# 0ul4N5OwsvE4jORz1CvS2SJ5aE8blC0sSZie5041Izo+ccEZgu8dkv5sapfJ7x0g
# jdThA9v8BAjqLejBHvWy9586CsDvEzZREraubHHduRgNIDEDvqjV1f8UwzgUyfMw
# XBkCAwEAAaOCAUkwggFFMB0GA1UdDgQWBBS8tsXufbAhNEo8nKhORK2+GK0tYDAf
# BgNVHSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBfBgNVHR8EWDBWMFSgUqBQ
# hk5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNyb3NvZnQl
# MjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmwwbAYIKwYBBQUHAQEEYDBe
# MFwGCCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2Nl
# cnRzL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNydDAM
# BgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMA4GA1UdDwEB/wQE
# AwIHgDANBgkqhkiG9w0BAQsFAAOCAgEA4UhI0gRUgmycpd1P0JhTFtnizwZJ55bH
# yA/+4EzLwDRJ4atPCPRx226osKgxB0rwEbyrS+49M5yAmAWzK1Upr4A8VPIwBqjM
# oi6DPNO/PEqN/k+iGVf/1GUSagZeKDN2wiEIBRqNFU3kOkc2C/rdcwlF5pqT5jOM
# XEnFRQE14+U8ewcuEoVlAu1YZu6YnA4lOYoBo7or0YcT726X5W4f27IhObceXLji
# RCUhvrlnKgcke0wuHBr7mrx0o5NYkV0/0I2jhHiaDp33rGznbyayXW5vpXmC0SOu
# zd3HfAf7LlNtbUXYMDp05NoTrmSrP5C8Gl+jbAG1MvaSrA5k8qFpxpsk1gT4k29q
# 6eaIKPGPITFNWELO6x0eYaopRKvPIxfvR/CnHG/9YrJiUxpwZ0TL+vFHdpeSxYTm
# eJ0bZeJR64vjdS/BAYO2hPBLz3vAmvYM/LIdheAjk2HdTx3HtboC771ltfmjkqXf
# DZ8BIneM4A+/WUMYrCasjuJTFjMwIBHhYVJuNBbIbc17nQLF+S6AopeKy2x38GLR
# jqcPQ1V941wFfdLRvYkW3Ko7bd74VvU/i93wGZTHq2ln4e3lJj5bTFPJREDjHpaP
# 9XoZCBju2GTh8VKniqZhfUGlvC1009PdAB2eJOoPrXaWRXwjKLchvhOF6jemVrSh
# AUIhN8S9uwQwggdxMIIFWaADAgECAhMzAAAAFcXna54Cm0mZAAAAAAAVMA0GCSqG
# SIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
# MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
# MTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkg
# MjAxMDAeFw0yMTA5MzAxODIyMjVaFw0zMDA5MzAxODMyMjVaMHwxCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBU
# aW1lLVN0YW1wIFBDQSAyMDEwMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKC
# AgEA5OGmTOe0ciELeaLL1yR5vQ7VgtP97pwHB9KpbE51yMo1V/YBf2xK4OK9uT4X
# YDP/XE/HZveVU3Fa4n5KWv64NmeFRiMMtY0Tz3cywBAY6GB9alKDRLemjkZrBxTz
# xXb1hlDcwUTIcVxRMTegCjhuje3XD9gmU3w5YQJ6xKr9cmmvHaus9ja+NSZk2pg7
# uhp7M62AW36MEBydUv626GIl3GoPz130/o5Tz9bshVZN7928jaTjkY+yOSxRnOlw
# aQ3KNi1wjjHINSi947SHJMPgyY9+tVSP3PoFVZhtaDuaRr3tpK56KTesy+uDRedG
# bsoy1cCGMFxPLOJiss254o2I5JasAUq7vnGpF1tnYN74kpEeHT39IM9zfUGaRnXN
# xF803RKJ1v2lIH1+/NmeRd+2ci/bfV+AutuqfjbsNkz2K26oElHovwUDo9Fzpk03
# dJQcNIIP8BDyt0cY7afomXw/TNuvXsLz1dhzPUNOwTM5TI4CvEJoLhDqhFFG4tG9
# ahhaYQFzymeiXtcodgLiMxhy16cg8ML6EgrXY28MyTZki1ugpoMhXV8wdJGUlNi5
# UPkLiWHzNgY1GIRH29wb0f2y1BzFa/ZcUlFdEtsluq9QBXpsxREdcu+N+VLEhReT
# wDwV2xo3xwgVGD94q0W29R6HXtqPnhZyacaue7e3PmriLq0CAwEAAaOCAd0wggHZ
# MBIGCSsGAQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUCBBYEFCqnUv5kxJq+gpE8
# RjUpzxD/LwTuMB0GA1UdDgQWBBSfpxVdAF5iXYP05dJlpxtTNRnpcjBcBgNVHSAE
# VTBTMFEGDCsGAQQBgjdMg30BATBBMD8GCCsGAQUFBwIBFjNodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9yeS5odG0wEwYDVR0lBAww
# CgYIKwYBBQUHAwgwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQD
# AgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9lJBb
# 186aGMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29t
# L3BraS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoG
# CCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwDQYJKoZI
# hvcNAQELBQADggIBAJ1VffwqreEsH2cBMSRb4Z5yS/ypb+pcFLY+TkdkeLEGk5c9
# MTO1OdfCcTY/2mRsfNB1OW27DzHkwo/7bNGhlBgi7ulmZzpTTd2YurYeeNg2Lpyp
# glYAA7AFvonoaeC6Ce5732pvvinLbtg/SHUB2RjebYIM9W0jVOR4U3UkV7ndn/OO
# PcbzaN9l9qRWqveVtihVJ9AkvUCgvxm2EhIRXT0n4ECWOKz3+SmJw7wXsFSFQrP8
# DJ6LGYnn8AtqgcKBGUIZUnWKNsIdw2FzLixre24/LAl4FOmRsqlb30mjdAy87JGA
# 0j3mSj5mO0+7hvoyGtmW9I/2kQH2zsZ0/fZMcm8Qq3UwxTSwethQ/gpY3UA8x1Rt
# nWN0SCyxTkctwRQEcb9k+SS+c23Kjgm9swFXSVRk2XPXfx5bRAGOWhmRaw2fpCjc
# ZxkoJLo4S5pu+yFUa2pFEUep8beuyOiJXk+d0tBMdrVXVAmxaQFEfnyhYWxz/gq7
# 7EFmPWn9y8FBSX5+k77L+DvktxW/tM4+pTFRhLy/AsGConsXHRWJjXD+57XQKBqJ
# C4822rpM+Zv/Cuk0+CQ1ZyvgDbjmjJnW4SLq8CdCPSWU5nR0W2rRnj7tfqAxM328
# y+l7vzhwRNGQ8cirOoo6CGJ/2XBjU02N7oJtpQUQwXEGahC0HVUzWLOhcGbyoYID
# UDCCAjgCAQEwgfmhgdGkgc4wgcsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMx
# JzAlBgNVBAsTHm5TaGllbGQgVFNTIEVTTjo4NjAzLTA1RTAtRDk0NzElMCMGA1UE
# AxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUA
# +5+wZOILDNrW1P4vjNwbUZy49PeggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEG
# A1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFt
# cCBQQ0EgMjAxMDANBgkqhkiG9w0BAQsFAAIFAOrWH/owIhgPMjAyNDExMDYxNzAz
# NTRaGA8yMDI0MTEwNzE3MDM1NFowdzA9BgorBgEEAYRZCgQBMS8wLTAKAgUA6tYf
# +gIBADAKAgEAAgIgywIB/zAHAgEAAgIUVTAKAgUA6tdxegIBADA2BgorBgEEAYRZ
# CgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0G
# CSqGSIb3DQEBCwUAA4IBAQC6B2PYrND0TFgA/D7Yl2lmOHFZesw8eBjANOGX2CKt
# VdJEl8SzyjXgzTw9+qKWTnAJbRjtBcJ/hCsEZe01KwmaeUlvMD8tKhY57c8yq+M3
# mjmI1x90xD5oIlcYPk0akvaGXUHmH1K1A+1rpkeTZCifwSNlG5T7jorMaTn1Rwt0
# NRCL+o7YzS7StBy0c1OGh96z4zU1bcz4F9OgHKPQGKsXRbv3pdnW555+ZvYbBMSr
# sam4qtrjCq95HC94Zb3+EzY1s/saiQNP0iwQkPftQc8o+4R+ZQFTScL5tcIFFb/8
# wQM4D1kIJf5x4PDeQTYEN2/SGwylS2XWZG88u9s0mxUIMYIEDTCCBAkCAQEwgZMw
# fDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMd
# TWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHxs0X1J+jAFtYAAQAA
# AfEwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRAB
# BDAvBgkqhkiG9w0BCQQxIgQgBBRqRFBSyzNGIOdyaAxpNcVcwlTWOEikE0AfSWEV
# JqAwgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCDVd/0+YUu4o8GqOOukaLAe
# 8MBIm7dGtT+RKiMBI/YReDCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBD
# QSAyMDEwAhMzAAAB8bNF9SfowBbWAAEAAAHxMCIEIL47nOnz2gy6bY/m04vqQQId
# hwh0ThCYiOlnhdQfBpsSMA0GCSqGSIb3DQEBCwUABIICAFvbSO0X4ei4cxnGtGrw
# jr0xYM2GchUXC0jghDkNMYiOc3d+ISnMOZDI2l1xolkm69OaKKxvNKNRdb6A5mfU
# ggSxCLsP81w3eXwEna2BdMpjgxRfDMYJ/j0JOCcIxwHNgP4Eyte5+AtCnpi+dH8J
# 0/45Ipu1EuQRNLnSywrnuzzp7PxwEvpxHjeXh6Ma1H4ZHFoTw90yaX5MwHCSaHPl
# GGRJCXWGn+ZcxVGR2/9Fy65MHAYjzyuYdzQ+iJdmSAh/vMxsGafq+DfEfADF2wwc
# uhNsvvdFh89n+RzKZ6pCp0tDMqor+rN/kl53x33yxCxEGxSL92AavtXqrfFxFnmQ
# 0CrJEtOLGmcPbv9DVmf+otpqItKZOIM4FoD6Bs3SRLf3ZEF4EFbo8PArZM/Absmj
# Ual2wTFY81pgdeh2zXXAap1eSviNlyjBfE2/LaLtoVEeydUv5BtMVTfWJqC6TMEa
# wJlh6eQOdai2eD/5axFQBnbjpQQmcaR3nmDRdQVyhP+2/opNOp6/Vu5CUeixdkT4
# haDZyCq6HKJEkFbn6bEIybHinvjNWHjhaDQ+Ntse6MgJn5IopAEylgLP3qOfAziX
# vBScm8lBvgy6xReFQqmUmqmlfNIchcBn49QWpxgaB28lreQHL529ibY0oyOdY99v
# et0DPFhLD/5kZEyS94etGlnE
# SIG # End signature block
