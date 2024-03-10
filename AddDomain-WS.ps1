function Invoke-AddWS {
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True,Position=1)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DomainName,
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True,Position=2)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DCIpAddress
    )

    # Check if the script is run with administrator privileges
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Warning "This script requires administrator privileges. Please run the script as an administrator."
        Exit
    }

    # Add DNS server
    $preferredDnsServer = $DCIpAddress  # Set the Domain Controller as preferred DNS server
    $alternateDnsServer =  (Get-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -AddressFamily IPv4).ServerAddresses[0]  # Set the original preferred DNS server as the alternate DNS server

    Write-Host "Adding the Domain Controller as the preferred DNS server..."

    # Set DNS server address
    Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses ($preferredDnsServer, $alternateDnsServer)

    Write-Host "DNS server has been configured:"
    Write-Host "  Preferred DNS Server: $preferredDnsServer"
    Write-Host "  Alternate DNS Server: $alternateDnsServer"

    Write-Host "Adding the computer to the domain $DomainName"
    #Add-Computer -Domain $DomainName -ComputerName $(hostname) -Restart -Force
    Add-Computer -Domain $DomainName -Restart -Force
}