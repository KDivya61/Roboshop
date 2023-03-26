source Common.sh
mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then 

 echo -e "\e[33mmissing pwd\e[0m"
exit 1
fi

print_head "disabling mysql older version"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "install mysql server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "enable mysql"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "start mysql"
systemctl start mysqld  &>>${log_file}
status_check $?

print_head "set pwd"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
status_check $?
