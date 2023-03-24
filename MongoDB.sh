source Common.sh

print_head "setup config fro mongodb"
cp configs/MongoDB.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?
print_head "installing mongodb"
yum install mongodb-org -y &>>${log_file}
status_check $?
print_head "IP changed for  mongodb"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}
status_check $?
print_head "ENable mongodb"
systemctl enable mongod &>>${log_file}
status_check $?
print_head "Start mongodb"
systemctl start mongod &>>${log_file} 

status_check $?