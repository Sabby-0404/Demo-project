app_tag=`git ls-remote https://github.com/javahometech/node-app HEAD | awk '{print $1}'`

docker_app="sabby404/demo-docker-repository:$app_tag"
docker build -t $docker_app .

podman login -u sabby404 -p yourpassword 

podman push $docker_app

scp -i /var/lib/jenkins/dev.pem deploy.sh ec2-user@172.31.1.31:/tmp

ssh -i /var/lib/jenkins/dev.pem ec2-user@172.31.1.31 chmod +x /tmp/deploy.sh

ssh -i /var/lib/jenkins/dev.pem ec2-user@172.31.1.31 /tmp/deploy.sh $docker_app
