pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "supriya2813/2244_ica2:latest"  // Replace with your Docker Hub image name
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Pull Docker Image') {
            steps {
                script {
                    echo "Pulling Docker image: ${DOCKER_IMAGE}"
                    sh "docker pull ${DOCKER_IMAGE}"
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    echo "Running Docker container on port 8082"
                    sh """
                    docker stop main-container || true
                    docker rm main-container || true
                    docker run -d --name main-container -p 8082:80 ${DOCKER_IMAGE}
                    """
                }
            }
        }
        stage('Test Website Accessibility') {
            steps {
                script {
                    echo "Testing website accessibility on port 8082"
                    sh "curl -I localhost:8082"
                }
            }
        }
    }
    post {
        success {
            echo "Main branch pipeline completed successfully!"
        }
        failure {
            echo "Main branch pipeline failed. Check logs for details."
        }
    }
}

