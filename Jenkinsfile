pipeline {
    agent any
    stages {
        stage('Pull Docker Image') {
            steps {
                script {
                    echo 'Pulling Docker image: supriya2813/my-static-site:latest'
                    sh 'docker pull supriya2813/my-static-site:latest'
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    echo 'Checking if port 8082 is available...'
                    def portInUse = sh(
                        script: "lsof -i :8082 | grep LISTEN || echo 'Not in use'",
                        returnStdout: true
                    ).trim()

                    if (portInUse.contains("LISTEN")) {
                        echo "Port 8082 is in use. Stopping the conflicting container..."
                        sh """
                            conflictingContainer=\$(docker ps -q --filter "publish=8082")
                            if [ -n "\$conflictingContainer" ]; then
                                docker stop \$conflictingContainer
                                docker rm \$conflictingContainer
                            fi
                        """
                    }

                    echo 'Running Docker container on port 8082...'
                    sh """
                        docker stop main-container || true
                        docker rm main-container || true
                        docker run -d --name main-container -p 8082:80 supriya2813/my-static-site:latest
                    """
                }
            }
        }
        stage('Test Website Accessibility') {
            steps {
                script {
                    echo 'Testing website accessibility...'
                    sh 'curl -I localhost:8082'
                }
            }
        }
    }
    post {
        failure {
            echo 'Main branch pipeline failed. Check logs for details.'
        }
        success {
            echo 'Main branch pipeline executed successfully.'
        }
    }
}


