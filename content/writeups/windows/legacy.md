### System data

Domain name: **LEGACY**
 
Windows versions: **Windows 5.1**

It seems to be vulnerable to `ms08-067`

Using `msfconsole` is super easy to exploit the system and get both the user and root flag at the same time. 
I'm going to try to exploit it manually.


### Flow process

````ad-note
title: Port scanning
collapse: closed

```ad-question
title: `nmap --open -T5 -p- -vvv 10.10.10.4 -n -Pn -oG nmap/allports`
collapse: closed
~~~python
PORT    STATE SERVICE      REASON
139/tcp open  netbios-ssn  syn-ack
445/tcp open  microsoft-ds syn-ack

```

```ad-question
title: `nmap -sCV -pC^V 10.10.10.4`
collapse: closed
~~~python
PORT    STATE SERVICE      VERSION
139/tcp open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp open  microsoft-ds Windows XP microsoft-ds
Service Info: OSs: Windows, Windows XP; CPE: cpe:/o:microsoft:windows, cpe:/o:microsoft:windows_xp

Host script results:
|_smb2-time: Protocol negotiation failed (SMB2)
|_clock-skew: mean: 5d00h02m50s, deviation: 1h24m51s, median: 4d23h02m50s
|_nbstat: NetBIOS name: LEGACY, NetBIOS user: <unknown>, NetBIOS MAC: 00:50:56:b9:36:6b (VMware)
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb-os-discovery: 
|   OS: Windows XP (Windows 2000 LAN Manager)
|   OS CPE: cpe:/o:microsoft:windows_xp::-
|   Computer name: legacy
|   NetBIOS computer name: LEGACY\x00
|   Workgroup: HTB\x00
|_  System time: 2022-01-08T00:37:37+02:00
```


```ad-question
title: `nmap -sU -Pn 10.10.10.4`
collapse: closed
~~~python
PORT    STATE SERVICE
137/udp open  netbios-ns

```

```ad-danger
title: `nmap --script "smb-vuln*" 10.10.10.4 -Pn`
collapse: closed
~~~python
Host script results:
|_smb-vuln-ms10-054: false
|_smb-vuln-ms10-061: ERROR: Script execution failed (use -d to debug)
| smb-vuln-ms08-067: 
|   VULNERABLE:
|   Microsoft Windows system vulnerable to remote code execution (MS08-067)
|     State: VULNERABLE
|     IDs:  CVE:CVE-2008-4250
|           The Server service in Microsoft Windows 2000 SP4, XP SP2 and SP3, Server 2003 SP1 and SP2,
|           Vista Gold and SP1, Server 2008, and 7 Pre-Beta allows remote attackers to execute arbitrary
|           code via a crafted RPC request that triggers the overflow during path canonicalization.
|           
|     Disclosure date: 2008-10-23
|     References:
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2008-4250
|_      https://technet.microsoft.com/en-us/library/security/ms08-067.aspx
| smb-vuln-ms17-010: 
|   VULNERABLE:
|   Remote Code Execution vulnerability in Microsoft SMBv1 servers (ms17-010)
|     State: VULNERABLE
|     IDs:  CVE:CVE-2017-0143
|     Risk factor: HIGH
|       A critical remote code execution vulnerability exists in Microsoft SMBv1
|        servers (ms17-010).
|           
|     Disclosure date: 2017-03-14
|     References:
|       https://technet.microsoft.com/en-us/library/security/ms17-010.aspx
|       https://blogs.technet.microsoft.com/msrc/2017/05/12/customer-guidance-for-wannacrypt-attacks/
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-0143


````


````ad-note
title: Mapping samba shares
collpase: closed

As a consecuence of having just SMB ports open (139, 445) Ill perform an smb mapping using `enum4linux`

```ad-question
title: `enum4linux 10.10.10.4`
collapse:closed

~~~python 
 ========================== 
|    Target Information    |
 ========================== 
Target ........... 10.10.10.4
RID Range ........ 500-550,1000-1050
Username ......... ''
Password ......... ''
Known Usernames .. administrator, guest, krbtgt, domain admins, root, bin, none


 ================================================== 
|    Enumerating Workgroup/Domain on 10.10.10.4    |
 ================================================== 
[+] Got domain/workgroup name: HTB

 ========================================== 
|    Nbtstat Information for 10.10.10.4    |
 ========================================== 
Looking up status of 10.10.10.4
	LEGACY          <00> -         B <ACTIVE>  Workstation Service
	HTB             <00> - <GROUP> B <ACTIVE>  Domain/Workgroup Name
	LEGACY          <20> -         B <ACTIVE>  File Server Service
	HTB             <1e> - <GROUP> B <ACTIVE>  Browser Service Elections
	HTB             <1d> -         B <ACTIVE>  Master Browser
	..__MSBROWSE__. <01> - <GROUP> B <ACTIVE>  Master Browser

	MAC Address = 00-50-56-B9-36-6B

```


```ad-question
title: ` crackmapexec smb 10.10.10.4`
collapse: closed

~~~python 
SMB         10.10.10.4      445    LEGACY           [*] Windows 5.1 (name:LEGACY) (domain:legacy) (signing:False) (SMBv1:True)
```
````
