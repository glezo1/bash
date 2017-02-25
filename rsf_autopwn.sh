#!/usr/bin/expect
set target_ip [lindex $argv 0];
set timeout 6000
spawn "you_know_what_i_mean.py"
expect " > " { send "use scanners/autopwn\r" }
expect " > " { send "set target $target_ip\r" }
expect " > " { send "run\r" }
expect " > " { send "exit\r" }

interact
