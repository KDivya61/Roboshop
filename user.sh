source Common.sh

print_head "configure NOde Js repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
status_check $?

print_head "install nodejs"
yum install nodejs -y

print_head "add roboshob user"
id roboshob  &>>${log_file}
if [ $? -ne 0]; then
useradd roboshop  &>>${log_file}
fi
status_check $?
print_head "add applic directory"
if [ ! -d /app]; then
mkdir /app  &>>${log_file}
fi
status_check $? 
print_head "download app content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>${log_file}
cd /app  
status_check $?
print_head "extracting app content"
unzip /tmp/catalogue.zip  &>>${log_file}
status_check $?
print_head "install nodejs dependencies"
npm install  &>>${log_file}
status_check $?
cp ${code_dir}/configs/user.service /etc/systemd/system/user.service  &>>${log_file}
status_check $?
print_head "reload file"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "enable user server"
systemctl enable user  &>>${log_file}
status_check $?

print_head "enable user server"
systemctl start user &>>${log_file}
status_check $?

print_head "install mongodb database"
yum install mongodb-org-shell -y   &>>${log_file}
status_check $?

print_head "Load the schema"
mongo --host mongodb.11servers.online </app/schema/user.js &>>${log_file}
status_check $?

