#Configure a failover relationship in standby mode for one scope with a shared secret
#Force is used to ommit a warning about the shared secret encryption
#The server on which the command is run is active
Add-DhcpServerv4Failover -Name 'DHCP01->DHCP02' -PartnerServer 'DHCP02.testcorp.com' -ScopeId '192.168.10.0' -MaxClientLeadTime 00:02:00 -AutoStateTransition $true -StateSwitchInterval 00:03:00 -ReservePercent 10 -SharedSecret 'secrettext' -Force

#Get info about the failover relationships on the server
Get-DhcpServerv4Failover
#Modify a failover relationship
Set-DhcpServerv4Failover -Name 'DHCP01->DHCP02' -ReservePercent 15

#Failover does not replicate scope settings like options, reservations or settings by itself
#You have to use
Invoke-DhcpServerv4FailoverReplication -ScopeId '192.168.1.0' -Force
#this command replicates data for this scope but can also be used to replicate for a failover relationship or all relationships on the server

#Get dhcp statistics with failover specific info
Get-DhcpServerv4ScopeStatistics -Failover | Format-List *

#In my test for hot standby mode when the primary dhcp was not available, the standby entered the partner down state after 3 minutes but did not show it is the active node after the client lead time (2 minutes); No Windows Updates applied on the 2 servers;

#Remove a DHCP failover relationship; deletes also the scopes from the servers with no active leases
Remove-DhcpServerv4Failover -Name 'DHCP01->DHCP02'

#Configure a failover relationship in load balance mode
Add-DhcpServerv4Failover -Name 'DHCP01<->DHCP02' -PartnerServer 'DHCP02.testcorp.com' -ScopeId '192.168.10.0' -MaxClientLeadTime 00:02:00 -AutoStateTransition $true -StateSwitchInterval 00:03:00 -SharedSecret 'secretDHCP' -LoadBalancePercent 60 -Force
#Also in this case if the partner is down, the other server does not show that it has 100% of IPs in the interface or powershell output



