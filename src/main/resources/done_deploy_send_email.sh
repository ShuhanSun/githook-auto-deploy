#!/bin/bash
project_path="/home/souche/projects/$1"
echo "deploy $1,  email is $2"
sh "$project_path/deploy.sh" > start.log
#sudo tail -300 /home/souche/projects/venus/tomcat-9.0.2-12180/logs/catalina.out > start.log
mail -s "$1 启动好了哦!" $2 < start.log