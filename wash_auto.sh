#!/usr/bin/expect

set usage "wash_auto.sh timeout <timeout> bssid <bssid> iface <iface> \[channel <channel\]"
set timeout	""
set bssid	""
set iface	""
set channel	""
#this shall contain 'operands', as timeout, bssid, iface, and, optionally, channel
set operand  	""
for {set x 0} {$x<$argc} {incr x} {
	if {$x%2==0} {
		set operand [lindex $argv $x]
	}
	if {$x%2!=0} {
		if {$operand=="timeout"}	{set timeout	[lindex $argv $x]}
		if {$operand=="bssid"}		{set bssid	[lindex $argv $x]}
		if {$operand=="iface"}		{set iface	[lindex $argv $x]}
		if {$operand=="channel"}	{set channel	[lindex $argv $x]}
	}
}

if {$timeout=="" || $bssid=="" || $bssid=="" || $argc%2!=0 } {
	puts $usage
	exit 1
}

set command "wash -i $iface --ignore-fcs"
if {$channel!=""} {
	set command "$command -c $channel"
}

eval spawn -noecho $command
expect "$bssid" { send "\003" }
