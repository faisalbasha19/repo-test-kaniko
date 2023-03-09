#!/usr/bin/env groovy

def label = "docker-jenkins-${UUID.randomUUID().toString()}"
def home = "/home/jenkins"
def workspace = "${home}/workspace/build-docker-jenkins"
def workdir = "${workspace}/src/localhost/docker-jenkins/"

def repoName = "qa-docker-nexus.mtnsat.io/dockerrepo/test"
def tag = "$repoName:latest"
def password = "Helxxe1234$$"

podTemplate(label: label,
        containers: [
                containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true),
            ],
            volumes: [
                hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock'),
            ],
        ) {
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
                    sh "docker login -u admin -p $password qa-docker-nexus.mtnsat.io"
                }                    
            }            
                
            stage('Docker Build') {
                container('docker') {
                    echo "Building docker image..."
                    sh "docker build -t $tag -f jenkins-docker/Dockerfile ."
                }
            }
        }
    }
}
