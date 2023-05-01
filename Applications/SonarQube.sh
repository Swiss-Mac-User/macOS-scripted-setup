#!/usr/bin/env zsh

function brewinstallAppSonarQube(){
	# --> Install SonarScanner for SonarQube
	brew install sonar-scanner

	# --> Install SonarQube
	if ! checkIfAppleSilicion; then
		# ...for Intel-based Macs
		SQdockerImage='sonarqube'
		docker pull $SQdockerImage
		#docker run -d --name "$SQdockerImage" -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 $SQdockerImage:latest
	else
		# ...for ARM-based Apple Silicon Macs
		SQdockerImage='sonarqube-arm'
		mkdir "$HOME/Downloads/$SQdockerImage"
		git clone https://github.com/SonarSource/docker-sonarqube "$HOME/Downloads/$SQdockerImage/"
		docker build -t "$SQdockerImage" "$HOME/Downloads/$SQdockerImage/docker-sonarqube/9/community"
		#docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 $SQdockerImage:latest
	fi

	# --> Run Container
	docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 $SQdockerImage:latest
}
export -f brewinstallAppSonarQube
