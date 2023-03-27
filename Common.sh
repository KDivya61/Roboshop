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
systemd_setup(){
    

print_head "copy systemD service file"
cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service  &>>${log_file}
status_check $?


sed -i -e "s/ROBOSHOP_USER_PASSWORD/${roboshop_app_password}/" /etc/systemd/system/${component}.service &>>${log_file}


print_head "reload file"
systemctl daemon-reload  &>>${log_file}
status_check $?

print_head "enable catalog server"
systemctl enable ${component}  &>>${log_file}
status_check $?

print_head "start the catalog server"
systemctl start ${component}  &>>${log_file}
status_check $?
}

Schema_setup()
{
    if [ "${schema_type}" == "mongo"]; then
    
    print_head "copy the  mongodb repo file"
cp  ${code_dir}/configs/MongoDB.repo /etc/yum.repos.d/mongodb.repo  &>>${log_file}
status_check $?

print_head "install mongodb database"
yum install mongodb-org-shell -y  &>>${log_file}
status_check $?

print_head "Load the schema"
mongo --host mongodb.11servers.online </app/schema/${component}.js  &>>${log_file}
status_check $?

elif [ "${schema_type}" == "mysql"]; then

print_head "install mysql schema"
yum install mysql -y  &>>${log_file}
status_check $?

print_head "Load the schema"
mysql -h mysql.11servers.online -uroot -${mysql_root_password} < /app/schema/${component}.sql  &>>${log_file}
status_check $?
fi
}

app_prereq_setup(){
    
    print_head "add roboshop user"
id roboshop  &>>${log_file}

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
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>${log_file}
status_check $?
cd /app  



print_head "extracting app content"
unzip /tmp/${component}.zip  &>>${log_file}
status_check $?

}

nodejs()
{
print_head "configure NOde Js repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${log_file}
status_check $?

print_head "install nodejs"
yum install nodejs -y  &>>${log_file}
status_check $?

app_prereq_setup


print_head "install nodejs dependencies"
npm install  &>>${log_file}
status_check $?


Schema_setup
systemd_setup
}
java(){
    
    print_head "install maven"
    yum install maven -y  &>>${log_file}
status_check $?

app_prereq_setup

print_head "dowmload dependencies"
mvn clean package  &>>${log_file}
mv target/${component}-1.0.jar ${component}.jar  &>>${log_file}
status_check $?



Schema_setup
systemd_setup
}
python(){
    
    print_head "install python"
    yum install python36 gcc python3-devel -y &>>${log_file}
status_check $?

app_prereq_setup

print_head "dowmload dependencies"
pip3.6 install -r requirements.txt  &>>${log_file}
status_check $?




systemd_setup
}
