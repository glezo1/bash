#################################################################################
#service_lifter.sh
#2017/03/23
#@glezo1
#call it as service_lifter.sh <file_path>, where <file_path> is the absolute path
#of a file containing the process (with its argument flags!), one per line,
#that need to be reloaded if they die.
#################################################################################

usage_string="Usage: service_lifter.sh <input_file>"

if [ "$#" -ne 1 ]; then
	echo $usage_string
	exit 1
fi

if [ ! -f $1 ]; then
	echo $usage_string
	echo "File does not exist"
	exit 1
fi

while [ 1 ]
do
	processes_to_watch=`cat $file_to_read_services`
	for current_process_to_watch in $processes_to_watch
	do
		is_alive=`ps aux | grep $current_process_to_watch | grep -v grep`
		if [ -z "${is_alive}" ]; then
			now_string=`date +"%Y-%m-%d %T"`
			echo "$now_string -> recalling $current_process_to_watch" | tee -a ./service_lifter.log
			eval "$current_process_to_watch &"
		fi
	done
	sleep 5
done
