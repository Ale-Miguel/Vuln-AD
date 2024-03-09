# Vuln-AD

```powershell
IEX((new-object net.webclient).downloadstring("http://192.168.0.181:8081/Setup-VulnAD.ps1"));Invoke-VulnAD -UsersLimit 100 -DomainName "vulnerablead.xyz";
```