---
geekdocCollapseSection: true
---

## Windows Section

Powershell script example
```powershell
Get-CimInstance -Class Win32_SystemDriver |
Where-Object {$_.State -eq "Running"} |
Where-Object {$_.StartMode -eq "Auto"}
```

