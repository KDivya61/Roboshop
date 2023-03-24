source Common.sh

print_head "setup config fro mongodb"
cp configs/MongoDB.repo /etc/yum.repos.d/mongo.repo 

print_head "installing mongodb"
yum install mongodb-org -y 

##print_head "IP for  mongodb"
##sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf 

print_head "ENable mongodb"
systemctl enable mongod 

print_head "Start mongodb"
systemctl start mongod  

