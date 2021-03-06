#!/bin/sh
#set -x #echo on

BASEDIR=$(dirname $0)
echo $BASEDIR
curdir=$PWD/$BASEDIR
now="$(date +'%d-%m-%Y-%H-%M-%S')"
DIRNAME=`dirname "$0"`
PROGNAME=`basename "$0"`
#JBOSS_HOME=/Users/ashakya/Documents/magnaworkspace/jboss-eap-6.2-brms-GA-delivery/jboss-eap-6.2-brms
#echo "jboss home :  ${JBOSS_HOME}"
localrepo=vizuribrms-insurance-rules
remotreponame=vizuri_brms-insurance-rules
function checkEnviroment(){
      #echo "Please provide the username for local git repo"
      read -p "Please provide the username for local brms git repo: " repousername
	if [ "x$repousername" = "x" ]; then
	
            echo "local git username is not set exiting"
            exit -1;
	fi
        
     
}

function gitConfig(){
	git config user.email "repousername@domain"
	git config user.name  "repousername"
}

function stageLocal(){
	cd $BASEDIR
	#mv HomeownerRepo HomeownerRepo$now
	mv $localrepo $localrepo$now
	gitConfig
	echo "****Please enter business-central password when prompted***"
	git clone ssh://$repousername@localhost:8001/$localrepo
	
  	
	#read -p "Enter Jboss Directory : " confirm_value
	#git clone $JBOSS_HOME/.niogit/HomeownerRepo.git
	
	cd $localrepo
	
	echo "****Now adding unfuddled remote use unfuddled credentials ***"
	git remote add unfuddle https://vizuri.unfuddle.com/git/$remotreponame/
	git fetch unfuddle
	git checkout -b unfuddlemaster unfuddle/master
	git pull unfuddle master
	git merge master
	
	git checkout master
	
	git merge unfuddlemaster
	
	echo "****Please enter business-central password when prompted***"
	git push origin master
	git checkout unfuddlemaster
	gitConfig
	echo "****Now pushing to unfuddled remote use the unfuddled credentials ***"
	git push unfuddle master

}

function deleteGitStage(){
	cd $curdir
	#rm -rf Home*
	rm -rf $localrepo*
	
}
checkEnviroment
stageLocal
#sleep 3
deleteGitStage
#rm -rf Home*
