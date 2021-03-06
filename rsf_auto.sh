#!/usr/bin/expect

set usage "rsf_auto.sh use <exploit> target <target> \[port <port>\]"
set timeout 6000
set target    ""
set exploit   ""
set port      ""
#this shall contain 'operands', as use,target,port, etc
set operand   ""
for {set x 0} {$x<$argc} {incr x} {
	if {$x%2==0} {
		set operand [lindex $argv $x]
	}
	if {$x%2!=0} {
		if {$operand=="use"}    {set exploit [lindex $argv $x]}
		if {$operand=="target"} {set target [lindex $argv $x]}
		if {$operand=="port"}   {set port [lindex $argv $x]}
	}
}

if {$exploit=="" || $target=="" || $argc%2!=0 } {
	puts $usage
	exit 1
}

spawn "you_know_what_i_mean.py
expect " > " { send "use $exploit\r" }
expect " > " { send "set target $target\r" }
if {$port!=""} {
	expect " > " { send "set port $port\r" }
}
expect " > " { send "run\r" }
expect " > " { send "exit\r" }
#some nasty exploits, such as exploits/dlink/dir_645_815_rce, will prompt an interactive shell, so we need to expect  >  and exit yet again
expect " > " { send "exit\r" }

interact
