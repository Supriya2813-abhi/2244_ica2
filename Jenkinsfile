pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'supriya2813/my-static-site:latest'
        CONTAINER_NAME = 'main-container'
        PORT = 8082
    }

    stages {
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
                    echo "Checking if port ${PORT} is in use..."
                    // Check if port is being used by any process, and kill the process if necessary
                    sh """
                        # Check if any process is using the port
                        if lsof -i :${PORT}; then
                            echo "Port ${PORT} is in use. Killing the process..."
                            fuser -k ${PORT}/tcp || true
                        fi
                    """

                    echo "Stopping and removing any existing container with the name ${CONTAINER_NAME}..."
                    // Stop and remove the Docker container if it exists
                    sh """
                        docker stop ${CONTAINER_NAME} || true
                        docker rm ${CONTAINER_NAME} || true
                    """

                    echo "Starting the Docker container on port ${PORT}..."
                    // Run the Docker container
                    def runContainerStatus = sh(script: "docker run -d --name ${CONTAINER_NAME} -p ${PORT}:80 ${DOCKER_IMAGE}", returnStatus: true)
                    if (runContainerStatus != 0) {
                        error "Failed to start Docker container on port ${PORT}"
                    }
                }
            }
        }

        stage('Test Website Accessibility') {
            steps {
                script {
                    echo "Testing website accessibility on http://localhost:${PORT}..."
                    def curlStatus = sh(script: "curl -I http://localhost:${PORT} || exit 1", returnStatus: true)
                    if (curlStatus != 0) {
                        error "Website is not accessible"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}

