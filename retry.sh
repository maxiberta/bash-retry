function retry {

RETRIES=5
SLEEP=1

usage() {
cat << EOF
usage: $0 options command

This script runs a command up to n times until the exit status is successful.

OPTIONS:
  -h    Show this message
  -n    Maximum number of times the command should be run (default: $RETRIES)
  -w    Seconds to wait between retries (default: $SLEEP)
EOF
}

while getopts “hn:w:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         n)
             RETRIES=$OPTARG
             ;;
         w)
             SLEEP=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

declare -a V=("$@")
CMD=${V[@]:$OPTIND-1}

n=0
until [ $n -ge $RETRIES ]; do
    $CMD
    [ $? -eq 0 ] && break
    n=$[$n+1]
    sleep $SLEEP
done

}

retry $@
