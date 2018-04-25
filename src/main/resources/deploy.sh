#!/bin/sh
export JAVA_HOME=/home/souche/tools/jdk1.8.0_151
export M2_HOME=/home/souche/tools/maven-3.3.9
export PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH

here=$(pwd)
echo $here
project_home=$here/weidian-venus
tomcat_home=$here/tomcat-9.0.2-12180
build_war_name=$project_home/web/target/ROOT.war

branch=deploy-test
operation=build_restart

echoUsage()
{
	echo 'usage: deploy [-a branch] [-o 'build_restart'|'restart']'
}

while getopts b:o: option
do
	case $option in
		b)
			branch=$OPTARG;;
		o)
			if [ "$OPTARG"x = "build_restart"x ]; then
				operation=build_restart
			elif [ "$OPTARG"x = "restart"x ]; then
				operation=restart
			else
				echoUsage
				exit 1
			fi
			;;
		?)
			#echo 'usage: deploy [-a branch] [-o build_restart|restart]'
			echoUsage
			exit 1;;
	esac
done

echo "\$branch = $branch"
echo "\$operation = $operation"

kill_tomcat() {
	jps -v | grep Bootstrap | grep $here | awk '{print $1}' | xargs kill -9
}

start_tomcat() {
	cd $tomcat_home/bin
	sh startup.sh
    tail -0f ../logs/catalina.out | while read logline
    do
        echo $logline
        if [ -n "$(echo $logline | grep "Server startup in")" ]; then
            pkill -P $$ tail
        fi
    done
}

restart_tomcat()
{
	kill_tomcat
	start_tomcat
}

if [ $operation = "restart" ] ; then
	restart_tomcat
	exit 0
fi

cd $project_home

git add --all

git stash

git fetch

if [ ! `git branch -r | grep "origin/$branch"` ]; then
	echo "the branch $branch does not exists!"
	exit 1;
else
	echo "the branch $branch does exists!"
fi
git checkout $branch
git pull

mvn -Dmaven.test.skip=true clean package
if [ ! -e $build_war_name ]; then
	echo 'build error, exit!'
	exit 1;
fi

sh web/script/config_server.sh load -Denv=DEV-B -Dtoken=9FADDxqUH3

kill_tomcat
rm -rf $tomcat_home/webapps/*
cp $build_war_name $tomcat_home/webapps/ROOT.war
start_tomcat