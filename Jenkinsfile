pipeline {
     agent any
    environment{
        DOCKER_TAG = getDockerTag()
    }
    stages{
        stage('Build Docker Image'){
            steps{
                sh "podman build . -t sabby404/demo-docker-repository:${DOCKER_TAG}"
            }
        }
        stage('DockerHub Push'){
	    steps{
            withCredentials([string(credentialsId: 'Sabby404', variable: 'dockerHubPwd')]) {
                sh "docker login -u sabby404 -p ${dockerHubPwd}"
		sh "podman push sabby404/demo-docker-repository:${DOCKER_TAG}"  
            }
        }
        stage('apply to kubernetes'){
            steps{
		sh "chmod +x changeTag.sh"
		sh "./changeTag.sh ${DOCKER_TAG}"
		sh "rm -rf pods.yml buildspec.yml"    
		sh "kubectl apply -f node-app-pod.yml"
		sh "kubectl apply -f services.yml"    
            }
        }
    }	    
}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
