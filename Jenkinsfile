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
          - name: dind-daemon 
            image: docker:20.10-dind
            resources:
              requests:
                  cpu: 20m 
                  memory: 512Mi 
            securityContext: 
              privileged: true
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
          - name: kaniko
            image: gcr.io/kaniko-project/executor:v1.6.0-debug
            imagePullPolicy: Always
            command:
            - sleep
            args:
            - 99d
            volumeMounts:
              - name: jenkins-docker-cfg
                mountPath: /kaniko/.docker
          volumes:
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
        //sh '/kaniko/executor -f `pwd`/Dockerfile -c `pwd` --insecure --skip-tls-verify --cache=true --destination=qa-docker-nexus.mtnsat.io/dockerrepo/testimage:1'
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
          sh 'dockerd --iptables=false'
          sh 'docker build -t qa-docker-nexus.mtnsat.io/dockerrepo/test:1 .'
        }
      }
    }        
  }
}
