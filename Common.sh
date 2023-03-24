code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
    
    echo -e "\e[33m$1\e[0m"
}
status_check(){
    
    if [ $1 -eq 0 ]; then
    echo SUCCESS
    else
    echo FAILURE
    echo "read the log file ${log_file} for more info"
    exit 1
    fi
}