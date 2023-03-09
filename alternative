#!/usr/bin/env groovy

def label = "docker-jenkins-${UUID.randomUUID().toString()}"
def home = "/home/jenkins"
def workspace = "${home}/workspace/build-docker-jenkins"
def workdir = "${workspace}/src/localhost/docker-jenkins/"

def repoName = "qa-docker-nexus.mtnsat.io/dockerrepo/test"
def tag = "$repoName:latest"
def password = "$PASSWORD"

podTemplate(yaml: '''
              apiVersion: v1
              kind: Pod
              spec:
                volumes:
                - name: docker-socket
                  emptyDir: {}
                containers:
                - name: docker
                  image: docker:19.03.1
                  readinessProbe:
                    exec:
                      command: [sh, -c, "ls -S /var/run/docker.sock"]
                  command:
                  - sleep
                  args:
                  - 99d
                  volumeMounts:
                  - name: docker-socket
                    mountPath: /var/run
                - name: docker-daemon
                  image: docker:19.03.1-dind
                  securityContext:
                    privileged: true
                  volumeMounts:
                  - name: docker-socket
                    mountPath: /var/run
''') {
    node(label) {
        dir(workdir) {
            stage('Checkout') {
                timeout(time: 3, unit: 'MINUTES') {
                    checkout scm
                }
            }
                
            stage('Docker Login'){
                container('docker') {
                    echo "Building docker image..."
                    sh 'docker version'                        
                    sh "docker login -u admin -p $password qa-docker-nexus.mtnsat.io"
                }                    
            }            
                
            stage('Docker Build') {
                container('docker') {
                    echo "Building docker image..."
                    sh "DOCKER_BUILDKIT=1 docker build --progress plain -t $tag -f jenkins-docker/Dockerfile ."
                }
            }
        }
    }
}
