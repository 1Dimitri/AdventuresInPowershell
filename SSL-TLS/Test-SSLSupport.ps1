# From
# https://www.sysadmins.lv/blog-en/test-web-server-ssltls-protocol-support-with-powershell.aspx

# Added some properties in the returned object:
# CheckCRL : was the Revocation List checked?
# Certificates (Local, Remote) and their Hashes 
function Test-ServerSSLSupport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$HostName,
        [UInt16]$Port = 443

    )
    process {
        $RetValue = New-Object psobject -Property ([ordered]@{
                Host                  = $HostName
                Port                  = $Port
                KeyExchange           = $null
                HashAlgorithm         = $null
                SSLv2                 = $false
                SSLv3                 = $false
                TLSv1_0               = $false
                TLSv1_1               = $false
                TLSv1_2               = $false
                LocalAddress          = $null
                RemoteAddress         = $null
                LocalPort             = $null
                RemotePort            = $null
                LocalCertificate      = $null
                RemoteCertificate     = $null
                LocalCertificateHash  = $null
                RemoteCertificateHash = $null
                CheckCRL              = $null
            })
        "ssl2", "ssl3", "tls", "tls11", "tls12" | % {
            $TcpClient = New-Object Net.Sockets.TcpClient
            try { $TcpClient.Connect($RetValue.Host, $RetValue.Port) }
            catch { Write-Host "`nThe host $HostName does not exist or not responding on port $Port `n" -ForegroundColor RED; break }
            $SslStream = New-Object -TypeName Net.Security.SslStream -ArgumentList $TcpClient.GetStream(), $true, ([System.Net.Security.RemoteCertificateValidationCallback] { $true })
            $SslStream.ReadTimeout = 15000
            $SslStream.WriteTimeout = 15000
            try {
                $SslStream.AuthenticateAsClient($RetValue.Host, $null, $_, $false)
                $RetValue.KeyExchange = $SslStream.KeyExchangeAlgorithm
                $RetValue.HashAlgorithm = $SslStream.HashAlgorithm
                $status = $true
            }
            catch {
                $status = $false
            }
            switch ($_) {
                "ssl2" { $RetValue.SSLv2 = $status }
                "ssl3" { $RetValue.SSLv3 = $status }
                "tls" { $RetValue.TLSv1_0 = $status }
                "tls11" { $RetValue.TLSv1_1 = $status }
                "tls12" { $RetValue.TLSv1_2 = $status }
            }
            switch ($retvalue.KeyExchange) {
                "44550" { $RetValue.KeyExchange = "ECDH_Ephem" }
            }

            $TcpClient.Client.LocalEndPoint.Address.I
            $RetValue.LocalAddress = $TcpClient.Client.LocalEndPoint.Address.IPAddressToString
            $RetValue.RemoteAddress = $TcpClient.Client.RemoteEndPoint.Address.IPAddressToString
                    
            $RetValue.LocalPort = $TcpClient.Client.LocalEndPoint.Port
            $RetValue.RemotePort = $TcpClient.Client.RemoteEndPoint.Port

            if ($SslStream.RemoteCertificate) {
                $RetValue.RemoteCertificate = $SslStream.RemoteCertificate
                $RetValue.RemoteCertificateHash = $SslStream.RemoteCertificate.GetCertHashString()

            }
            if ($SslStream.LocalCertificate) {            
                $RetValue.LocalCertificate = $SslStream.LocalCertificate
                $RetValue.LocalCertificateHash = $SslStream.LocalCertificate.GetCertHashString()
            }
            $Retvalue.CheckCRL = $SslStream.CheckCertRevocationStatus

            # dispose objects to prevent memory leaks
            $TcpClient.Dispose()
            $SslStream.Dispose()
        }
        $RetValue
    }
}
