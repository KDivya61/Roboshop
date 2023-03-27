ource Common.sh
roboshop_app_password=$1
if [ "${roboshop_app_password}" == "mysql" ]; then
echo -e "\e[33mmissing pwd\e[0m"
exit 1
fi
print_head "setup erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_file}
status_check $?

print_head "install erlang"
yum install erlang -y &>>${log_file}
status_check $?

print_head "setup rabbitmq reposs"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_file}
status_check $?

print_head "install erlang and rabbitmq"
yum install rabbitmq-server erlang -y &>>${log_file}
status_check $?

print_head "enable rabbitmq"
systemctl enable rabbitmq-server &>>${log_file}
status_check $?

print_head "start rabbitmq"
systemctl start rabbitmq-server &>>${log_file}
status_check $?

print_head "dowmload dependencies"
rabbitmqctl add_user roboshop ${roboshop_app_password} &>>${log_file}
status_check $?

print_head "add app user"
rabbitmqctl set_user_tags roboshop administrator &>>${log_file}
status_check $?

print_head "configure app permisiions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check $?