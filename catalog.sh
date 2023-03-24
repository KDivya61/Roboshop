source Common.sh

print_head "configure NOde Js repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${log_file}

print_head "install nodejs"
yum install nodejs -y  &>>${log_file}

print_head "add roboshob user"
useradd roboshop  &>>${log_file}

print_head "add applic directory"
mkdir /app  &>>${log_file}

print_head "remove old content"
rm -rf /app/*  &>>${log_file}

print_head "download app content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>${log_file}
cd /app  

print_head "extracting app content"
unzip /tmp/catalogue.zip  &>>${log_file}

print_head "install nodejs dependencies"
npm install  &>>${log_file}

print_head "copy systemD service file"
cp configs/catalog.service /etc/systemd/system/catalogue.service  &>>${log_file}

print_head "reload file"
systemctl daemon-reload  &>>${log_file}

print_head "enable catalog server"
systemctl enable catalogue  &>>${log_file}

print_head "start catalog server"
systemctl start catalogue  &>>${log_file}

print_head "copy mongodb repo file"
cp configs/MongoDB.repo /etc/yum.repos.d/mongodb.repo  &>>${log_file}

print_head "install mongodb"
yum install mongodb-org-shell -y  &>>${log_file}

print_head "Load schema"
mongo --host mongodb.11servers.online </app/schema/catalogue.js  &>>${log_file}