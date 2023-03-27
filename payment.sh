source Common.sh

${mysql_root_password}=$1
if [ "${mysql_root_password}" == "mysql" ]; then
echo -e "\e[33mmissing pwd\e[0m"
exit 1
fi

component=payment

python