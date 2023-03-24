source Common.sh
print_head "install redis repo files "
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status_check $?

print_head "enable dnf for redis"
dnf module enable redis:remi-6.2 -y &>>${log_file}
status_check $?

print_head "install redis"
yum install redis -y &>>${log_file}
status_check $?

print_head "update redis listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
status_check $?

print_head "enable redis"
systemctl enable redis &>>${log_file}
status_check $?

print_head "start redis"
systemctl start redis &>>${log_file}
status_check $?