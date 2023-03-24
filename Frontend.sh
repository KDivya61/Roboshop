source Common.sh

print_head "Installing Nginx"
yum install nginx -y &>>${log_file}
print_echoo

print_head "removing Old Content Nginx"
rm -rf /usr/share/nginx/html/* &>>${log_file}
print_echoo

print_head "Downloading Front end"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>${log_file} 
print_echoo
print_head "Extracting Nginx"
cd /usr/share/nginx/html  &>>${log_file}
unzip /tmp/frontend.zip  &>>${log_file}
print_echoo
print_head "Copying Nginx"
cp ${code_dir}/configs/Nginx-robo.conf /etc/nginx/default.d/roboshop.conf  &>>${log_file}
print_echoo
print_head "Enabling Nginx"
systemctl enable nginx  &>>${log_file}
print_echoo
print_head "Starting Nginx"
systemctl start nginx  &>>${log_file}
print_echoo