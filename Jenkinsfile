pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "mehtasham/jenkins-practice:${env.BUILD_NUMBER}"
        // Use a different port that doesn't conflict with Jenkins
        APP_PORT = "8081"
    }
    
    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        
        stage('Clone Repository') {
            steps {
                git branch: 'main',
                url: 'https://github.com/M-Ehtasham/jenkins-practice.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image: ${DOCKER_IMAGE}"
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }
        
        stage('Test Container') {
            steps {
                script {
                    echo "Testing the Docker container on port ${APP_PORT}..."
                    docker.image("${DOCKER_IMAGE}").withRun("-p ${APP_PORT}:80") { c ->
                        sh 'sleep 10'
                        sh "curl -s -f http://localhost:${APP_PORT} > index_test.html && echo '✅ Website is accessible'"
                    }
                }
            }
        }
        
        stage('Deploy Container') {
            steps {
                script {
                    echo "Deploying container on port ${APP_PORT}..."
                    // Stop and remove any existing container
                    sh """
                        docker stop jenkins-practice-container || true
                        docker rm jenkins-practice-container || true
                    """
                    // Run new container on different port
                    sh "docker run -d -p ${APP_PORT}:80 --name jenkins-practice-container ${DOCKER_IMAGE}"
                    echo "✅ Container deployed successfully!"
                    echo "🌐 Access your application at: http://192.168.229.128:${APP_PORT}"
                }
            }
        }
    }
    
    post {
        always {
            echo "Build completed: ${currentBuild.result}"
            // Cleanup test containers
            sh 'docker stop test-container || true && docker rm test-container || true'
        }
        success {
            echo "🎉 Pipeline executed successfully!"
            echo "📢 Your application is now running at: http://192.168.229.128:${APP_PORT}"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}
