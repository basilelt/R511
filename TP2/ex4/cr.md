# TP2

## Ex 4

### Configure SSH Router

```sh
enable
configure terminal

hostname r1

ip domain-name example.com

crypto key generate rsa modulus 2048

username admin privilege 15 secret toto

ip ssh version 2

ip ssh time-out 60
ip ssh authentication-retries 3

line vty 0 4
 transport input ssh
 login local
 exit

end
write memory
```

### Configure SSH Switch

```sh
enable
configure terminal

interface Vlan1
 ip address 192.168.56.103 255.255.255.0
 no shutdown
 exit

interface Ethernet0/0
 switchport mode access
 switchport access vlan 1
 no shutdown
 exit

hostname sw1

ip domain-name example.com

crypto key generate rsa modulus 2048

username admin privilege 15 secret toto

ip ssh version 2

ip ssh time-out 60
ip ssh authentication-retries 3

line vty 0 4
 transport input ssh
 login local
 exit

end
write memory
```

<u>Partie 1</u>

```bash
(.venv)  ✘ toto@LPTC-PC1M4VZ3  /mnt/c/Users/blt/Documents/github/R511/TP2/ex4   main ±  ansible-playbook -i inventory.yml backup_router.yml

PLAY [AUTOMATIC BACKUP OF RUNNING-CONFIG] ********************************************************************************************************************

TASK [DISPLAYING THE RUNNING-CONFIG] *************************************************************************************************************************
ok: [R1]

TASK [ENSURE BACKUPS DIRECTORY EXISTS] ***********************************************************************************************************************
changed: [R1 -> localhost]

TASK [SAVE OUTPUT TO ./backups/] *****************************************************************************************************************************
changed: [R1]

PLAY RECAP ***************************************************************************************************************************************************
R1                         : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


(.venv)  toto@LPTC-PC1M4VZ3  /mnt/c/Users/blt/Documents/github/R511/TP2/ex4   main ±  ll backups
total 4
drwxrwxrwx 1 toto toto 4096 Oct 11 11:08 .
drwxrwxrwx 1 toto toto 4096 Oct 11 11:08 ..
-rwxrwxrwx 1 toto toto 1102 Oct 11 11:08 show_run_R1.txt


(.venv)  toto@LPTC-PC1M4VZ3  /mnt/c/Users/blt/Documents/github/R511/TP2/ex4   main ±  cat backups/show_run_R1.txt 
Building configuration...

Current configuration : 1042 bytes
!
! Last configuration change at 12:53:53 EET Fri Oct 11 2024
!
version 15.4
service config
service timestamps debug datetime msec
service timestamps log datetime msec
no service password-encryption
!
hostname r1
!
boot-start-marker
boot-end-marker
!
no aaa new-model
clock timezone EET 2 0
mmi polling-interval 60
no mmi auto-configure
no mmi pvc
mmi snmp-timeout 180
!
ip domain name example.com
ip cef
no ipv6 cef
!
multilink bundle-name authenticated
!
username admin privilege 15 secret 5 $1$hWrR$G9oLQg6r06ZauD4whfzBy.
!
redundancy
!
ip ssh time-out 60
ip ssh version 2
!
interface Ethernet0/0
 ip address dhcp
!
interface Ethernet0/1
 no ip address
 shutdown
!
interface Ethernet0/2
 no ip address
 shutdown
!
interface Ethernet0/3
 no ip address
 shutdown
!
ip forward-protocol nd
!
no ip http server
no ip http secure-server
!
control-plane
!
line con 0
 logging synchronous
line aux 0
line vty 0 4
 login local
 transport input ssh
!
end%
```

<u>Partie 2</u>

```bash
(.venv)  toto@LPTC-PC1M4VZ3  /mnt/c/Users/blt/Documents/github/R511/TP2/ex4   main ±  ansible-playbook -i inventory.yml router_ipv4_conf.yml

PLAY [AUTOMATIC BACKUP OF INTERFACE STATUS] ******************************************************************************************************************

TASK [Config_ipv4_interface] *********************************************************************************************************************************
[WARNING]: To ensure idempotency and correct diff the input configuration lines should be similar to how they appear if present in the running configuration
on device
changed: [R1]

TASK [DISPLAYING IP INTERFACE BRIEF] *************************************************************************************************************************
ok: [R1]

TASK [ENSURE ios_show DIRECTORY EXISTS] **********************************************************************************************************************
ok: [R1 -> localhost]

TASK [SAVE INTERFACE STATUS TO ./ios_show/] ******************************************************************************************************************
ok: [R1]

PLAY RECAP ***************************************************************************************************************************************************
R1                         : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

(.venv)  toto@LPTC-PC1M4VZ3  /mnt/c/Users/blt/Documents/github/R511/TP2/ex4   main ±  ll ios_show 
total 0
drwxrwxrwx 1 toto toto 4096 Oct 11 11:17 .
drwxrwxrwx 1 toto toto 4096 Oct 11 11:15 ..
-rwxrwxrwx 1 toto toto  420 Oct 11 11:17 show_ip_intr_br_R1.txt
(.venv)  toto@LPTC-PC1M4VZ3  /mnt/c/Users/blt/Documents/github/R511/TP2/ex4   main ±  cat ios_show/show_ip_intr_br_R1.txt 
Interface                  IP-Address      OK? Method Status                Protocol
Ethernet0/0                192.168.56.102  YES DHCP   up                    up
Ethernet0/1                unassigned      YES unset  administratively down down
Ethernet0/2                10.10.10.1      YES manual up                    up
Ethernet0/3                unassigned      YES unset  administratively down down%
```

<u>Switch</u>

```bash
(.venv)  ✘ toto@LPTC-PC1M4VZ3  /mnt/c/Users/blt/Documents/github/R511/TP2/ex4   main ±  ansible-playbook -i inventory.yml switch_conf.yml

PLAY [Configure Switch] **************************************************************************************************************************************

TASK [Change hostname to SW_BLT] *****************************************************************************************************************************
[WARNING]: To ensure idempotency and correct diff the input configuration lines should be similar to how they appear if present in the running configuration
on device
changed: [sw1]

TASK [Create VLAN 200] ***************************************************************************************************************************************
changed: [sw1]

TASK [Configure interface Ethernet0/1 for VLAN 200] **********************************************************************************************************
changed: [sw1]

TASK [Configure interface Ethernet0/2 for VLAN 200] **********************************************************************************************************
changed: [sw1]

TASK [DISPLAYING THE RUNNING-CONFIG] *************************************************************************************************************************
ok: [sw1]

TASK [ENSURE BACKUPS DIRECTORY EXISTS] ***********************************************************************************************************************
ok: [sw1 -> localhost]

TASK [SAVE OUTPUT TO ./backups/] *****************************************************************************************************************************
changed: [sw1]

PLAY RECAP ***************************************************************************************************************************************************
sw1                        : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

(.venv)  toto@LPTC-PC1M4VZ3  /mnt/c/Users/blt/Documents/github/R511/TP2/ex4   main ±  ll backups                                                          
total 8
drwxrwxrwx 1 toto toto 4096 Oct 11 11:44 .
drwxrwxrwx 1 toto toto 4096 Oct 11 11:37 ..
-rwxrwxrwx 1 toto toto 1102 Oct 11 11:08 show_run_R1.txt
-rwxrwxrwx 1 toto toto 1225 Oct 11 11:44 show_run_sw1.txt
(.venv)  toto@LPTC-PC1M4VZ3  /mnt/c/Users/blt/Documents/github/R511/TP2/ex4   main ±  cat backups/show_run_sw1.txt       
Building configuration...

Current configuration : 1165 bytes
!
! Last configuration change at 13:44:36 EET Fri Oct 11 2024 by admin
!
version 15.2
service timestamps debug datetime msec
service timestamps log datetime msec
no service password-encryption
service compress-config
!
hostname SW_BLT
!
boot-start-marker
boot-end-marker
!
username admin privilege 15 secret 5 $1$uY/b$CopQq65Dak5jeM.WOB9Ou0
no aaa new-model
clock timezone EET 2 0
!
ip domain-name example.com
ip cef
no ipv6 cef
!
spanning-tree mode pvst
spanning-tree extend system-id
!
interface Ethernet0/0
 switchport mode access
!
interface Ethernet0/1
 switchport access vlan 200
 switchport mode access
!
interface Ethernet0/2
 switchport access vlan 200
 switchport mode access
!
interface Ethernet0/3
!
interface Vlan1
 ip address 192.168.56.103 255.255.255.0
!
ip forward-protocol nd
!
ip http server
!
ip ssh time-out 60
ip ssh version 2
ip ssh server algorithm encryption aes128-ctr aes192-ctr aes256-ctr
ip ssh client algorithm encryption aes128-ctr aes192-ctr aes256-ctr
!
control-plane
!
line con 0
 logging synchronous
line aux 0
line vty 0 4
 login local
 transport input ssh
!
end%
```
