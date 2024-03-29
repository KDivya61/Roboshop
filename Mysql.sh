source Common.sh
mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then 

 echo -e "\e[33mmissing pwd\e[0m"
exit 1
fi

print_head "disabling mysql older version"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "copy mysql repo"
cp ${code_dir}/configs/Mysql.repo /etc/yum.repos.d/Mysql.repo &>>${log_file}
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

echo show databases | mysql -uroot -p${mysql_root_password} &>>${log_file}

if [ $? -ne 0]; then
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
fi
status_check $?

