#!/bin/bash

i=0
subject="ooo"
while :
 do
	http_code="$(curl -s -w "%{http_code} \\n" --head http://localhost:12180/api -o /dev/null)"
	echo $http_code
	if [ $http_code -eq "200" ];
	then
		echo 'venus start success!'
		subject="venus启动完成!"
		break;
	fi

	let i++

	if [ $i -gt 60 ];
	then
    	echo 'venus start failed!'
    	subject="venus启动失败！"
    	break;
  	fi

	echo 'venus 启动中...'
	sleep 5s
done

echo "send email -->"
sudo tail -300 /home/souche/projects/venus/tomcat-9.0.2-12180/logs/catalina.out > start.log
mail -s $subject sunshuhan@souche.com < start.log