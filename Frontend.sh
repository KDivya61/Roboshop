code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

yum install nginx -y &>>${log_file}
rm -rf /usr/share/nginx/html/* &>>${log_file}
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>${log_file} 
cd /usr/share/nginx/html  &>>${log_file}
unzip /tmp/frontend.zip  &>>${log_file}

cp ${code_dir}/configs/Nginx-robo.conf /etc/nginx/default.d/roboshop.conf  &>>${log_file}

systemctl enable nginx  &>>${log_file}
systemctl start nginx  &>>${log_file}