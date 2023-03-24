source Common.sh

print_head "configure NOde Js repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${log_file}
status_check $?
print_head "install nodejs"
yum install nodejs -y  &>>${log_file}
status_check $?
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
print_head "remove old content"
rm -rf /app/*  &>>${log_file}
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
print_head "copy systemD service file"
cp configs/catalog.service /etc/systemd/system/catalog.service  &>>${log_file}
status_check $?
print_head "reload file"
systemctl daemon-reload  &>>${log_file}
status_check $?
print_head "enable catalog server"
systemctl enable catalogue  &>>${log_file}
status_check $?
print_head "start catalog server"
systemctl start catalogue  &>>${log_file}
status_check $?
print_head "copy mongodb repo file"
cp configs/MongoDB.repo /etc/yum.repos.d/mongodb.repo  &>>${log_file}
status_check $?
print_head "install mongodb"
yum install mongodb-org-shell -y  &>>${log_file}
status_check $?
print_head "Load schema"
mongo --host mongodb.11servers.online </app/schema/catalogue.js  &>>${log_file}
status_check $?