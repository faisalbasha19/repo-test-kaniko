pipeline {
  agent {
    kubernetes {
      //cloud 'kubernetes'
      defaultContainer 'kaniko'
      yaml '''
        kind: Pod
        spec:
          containers:
          - name: docker
            image: docker:latest
            imagePullPolicy: Always
            command:
            - cat
            tty: true
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
    stage('Build with Kaniko') {
      steps {
        git 'https://github.com/jenkinsci/docker-inbound-agent.git'
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
    stage('Docker build'){
      steps {
        container('docker'){
          sh 'docker build -t qa-docker-nexus.mtnsat.io/dockerrepo/test:1 .'
        }
      }
    }        
  }
}
