pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'supriya2813/my-static-site'
        DOCKER_TAG = "develop-${env.BUILD_ID}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'develop', url: 'https://github.com/Supriya2813-abhi/2244_ica2.git'
            }
        }

        stage('Build Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE}:latest .'
                    sh 'docker tag ${DOCKER_IMAGE}:latest ${DOCKER_IMAGE}:${DOCKER_TAG}'
                }
            }
        }

        stage('Run Container & Test') {
            steps {
                script {
                    sh 'docker run -d -p 8081:80 ${DOCKER_IMAGE}:${DOCKER_TAG}'
                    sh 'curl -I http://localhost:8081'  // Testing if website is accessible
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-auth', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                        sh 'docker push ${DOCKER_IMAGE}:latest'
                        sh 'docker push ${DOCKER_IMAGE}:${DOCKER_TAG}'
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker rm -f $(docker ps -a -q)'  // Clean up any containers
        }
    }
}

