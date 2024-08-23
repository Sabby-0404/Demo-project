pipeline {
    agent any

    stages {
        stage('Initialize') {
            steps {
                script {
                    env.DOCKER_TAG = getDockerTag()
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "podman build . -t sabby404/demo-docker-repository:${DOCKER_TAG}"
            }
        }

        stage('DockerHub Push') {
            steps {
                withCredentials([string(credentialsId: 'Sabby404', variable: 'dockerHubPwd')]) {
                    sh "podman login -u sabby404 -p ${dockerHubPwd}"
                    sh "podman push sabby404/demo-docker-repository:${DOCKER_TAG}"
                }
            }
        }

        stage('Apply to Kubernetes') {
            steps {
                sh "chmod +x changeTag.sh"
                sh "./changeTag.sh ${DOCKER_TAG}"
                sh "rm -rf pods.yml buildspec.yml"
                sh "kubectl apply -f node-app-pod.yml --validate=false"
                sh "kubectl apply -f services.yml"
            }
        }
    }
}

def getDockerTag() {
    return sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
}
