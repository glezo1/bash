#!/usr/bin/expect

set usage			"airodump-ng.sh timeout <timeout> bssid <bssid> <airodump_args>"
set timeout			""
set bssid			""
set parsing_state	"0"
#this shall contain 'operators', as timeout, bssid, iface, and, optionally, channel
set operator  		""
set command			""
for {set x 0} {$x<$argc} {incr x} {
	if { $parsing_state=="0"} {
		if {$x%2==0} {
			set operator [lindex $argv $x]
		}
		if {$x%2!=0} {
			if {		$operator=="timeout"}	{
				set timeout	[lindex $argv $x]
			} elseif {	$operator=="bssid"}	{
				set bssid	[lindex $argv $x]
			}
		}
		if {$timeout!="" && $bssid!="" } {
			set parsing_state "1"
		}
	} else {
		set command "$command [lindex $argv $x]"
	}
}

if {$timeout=="" || $bssid==""} {
	puts $usage
	exit 1
}


eval spawn -noecho $command
expect "$bssid" { 
	send "\003" 
}
