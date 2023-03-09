pipeline {
  environment {
    registry = "qa-docker-nexus.mtnsat.io"
    registryCredential = 'nexus'
    PASSWORD = "${PASSWORD}"
  }
  agent {
    kubernetes {
      //cloud 'kubernetes'
      defaultContainer 'docker-cmds'
      yaml '''
        kind: Pod
        spec:
          containers:
          - name: docker-cmds 
            image: docker:19.03.1
            command: ['sleep', '99d'] 
            resources:
              requests: 
                  cpu: 10m 
                  memory: 256Mi 
            env:
            - name: DOCKER_HOST 
              value: tcp://localhost:2375
            volumeMounts:
            - name: docker-socket
              mountPath: /var/run/docker.sock
          - name: dind-daemon 
            image: docker:20.10-dind
            resources:
              requests:
                  cpu: 20m 
                  memory: 512Mi 
            securityContext: 
              privileged: true
            volumeMounts:
            - name: docker-socket
              mountPath: /var/run/docker.sock
            volumeMounts:
            - name: docker-graph-storage 
              mountPath: /var/lib/docker
          - name: maven
            image: maven:alpine
            imagePullPolicy: Always
            command:
            - cat
            tty: true
          - name: node
            image: node:16-alpine3.12
            imagePullPolicy: Always
            command:
            - cat
            tty: true
          volumes:
          - name: docker-socket
            hostPath:
              path: /var/run/docker.sock
          - name: docker-graph-storage 
            hostPath:
              path: /tmp
              type: Directory
          - name: jenkins-docker-cfg
            projected:
              sources:
              - secret:
                  name: regcrednex
                  items:
                    - key: .dockerconfigjson
                      path: config.json
'''
    }
  }
  stages {    
    stage('Git sCM Checkout') {
      steps {
        git branch: 'main', credentialsId: 'gitssh-1', url: 'https://github.com/faisalbasha19/repo-test-kaniko.git'
      }
    }
    stage('run maven'){
      steps {
        container('maven'){
         sh 'mvn -version'
        }
      }
    }
    stage('run node'){
      steps {
        container('node'){
         sh 'npm version'
        }
      }
    }
   stage('Docker login'){
         steps {
             container('docker-cmds') {
               withCredentials([usernamePassword(credentialsId: 'nexus', passwordVariable: 'password', usernameVariable: 'username')]) {
                 sh 'docker login -u admin -p ${PASSWORD} qa-docker-nexus.mtnsat.io'                               
                  }
                }
         }         
      }    
    stage('Docker build'){
      steps {
        container('docker-cmds'){
          sh 'docker --version'
          sh 'ls -ahl'
          sh 'pwd'
          sh 'cd /var/run/'
          sh 'pwd'
          sh 'ls -ahl'
          sh 'cat /etc/passwd'
          sh 'id'
          sh 'cat /etc/*release*'
          sh 'groupadd docker'
          sh 'usermod -a -G docker admin'
          sh 'chown -R docker:docker /var/run/docker.socket'
          sh 'chmod 666 /var/run/docker.socket'
          sh 'dockerd --iptables=false'
          sh 'docker build -t qa-docker-nexus.mtnsat.io/dockerrepo/test:1 .'
        }
      }
    }        
  }
}
