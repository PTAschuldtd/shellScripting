#!/bin/bash

# denis.schuldt@pta.de
# get system information and print it to a .html file in the current directory

VERSION="0.0.2-RC1"
START=$(date +%s.%N)
TITLE="System Information Report"
FILENAME="system_report_$START.html"

function getUptime(){
  echo $(uptime)
}

function getDiskUsage(){
  echo "<PRE>$(df -h)</PRE>"
}

function getRAMUsage(){
  echo "<PRE>$(free -h)</PRE>"
}

function getProcessSnapshot(){
  echo "<PRE>$(top -n 1 -b)</PRE>"   
}

function usage(){
  echo "
  $TITLE --print system information into a html file in the current working directory
  Please report errors to denis.schuldt@pta.de
  --------------------------------------------
  
  usage: $(basename $0) [-f filename | -h | -v]
  
  arguments:
    -f, --filename	(optional) specify a filename for the generated report. If omitted, default name will be 'system_report_\$TIMESTAMP.html'  
    -h, --help		show this help
    -v, --version	show program version information
  "
}

while [[ $# -gt 0 ]]
  do
    key="$1"
    case $key in
	-f|--filename)
	FILENAME="$2"
	shift 
	;;
	-h|--help)
	usage
	exit 0
	;;
	-v|--version)
	echo $VERSION
	exit 0
	;;
	*)
	echo "unknown argument; use -h for help" >&2
	exit 1
	;;
    esac
    shift
  done

cat > $(pwd)/$FILENAME << EOF 
<!DOCTYPE html>
<HTML>
   <HEAD>
     <TITLE>$TITLE for $HOSTNAME</TITLE>
     <meta charset="utf-8">
   </HEAD>
   <BODY>
     <H1>$TITLE</H1>
     <p>Generated $TIMESTAMP by user $USER</p>
     <br>
     <p><b>Uptime:</b> $(getUptime)</p>
     <p><b>Disk usage:</b> $(getDiskUsage)</p>
     <p><b>RAM usage:</b> $(getRAMUsage)</p>
     <p><b>Process snapshot:</b> $(getProcessSnapshot)</p>
   </BODY>
</HTML>
EOF

END=$(date +%s.%N)

echo "system report $FILENAME successfully generated in $(echo "$END - $START" | bc) seconds."

exit 0