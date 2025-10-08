pipeline {
    agent any
    
    environment {
        // Use your Docker Hub username - IMPORTANT: Change this to your actual Docker Hub username
        DOCKERHUB_USERNAME = "mehtasham"
        DOCKER_IMAGE = "${DOCKERHUB_USERNAME}/jenkins-practice:${env.BUILD_NUMBER}"
        APP_PORT = "8081"
    }
    
    stages {
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
                    echo "Testing the Docker container..."
                    docker.image("${DOCKER_IMAGE}").withRun("-p ${APP_PORT}:80") { c ->
                        sh 'sleep 5'
                        sh "curl -s -f http://localhost:${APP_PORT} && echo '✅ Website is accessible'"
                    }
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "Pushing image to Docker Hub..."
                    // Use the credentials ID you set up earlier (probably 'docker-hub')
                    docker.withRegistry('', 'docker-hub') {
                        docker.image("${DOCKER_IMAGE}").push()
                        
                        // Also push as 'latest'
                        docker.image("${DOCKER_IMAGE}").push('latest')
                    }
                    echo "✅ Successfully pushed: ${DOCKER_IMAGE}"
                    echo "✅ Successfully pushed: ${DOCKERHUB_USERNAME}/jenkins-practice:latest"
                }
            }
        }
        
        stage('Deploy Container') {
            steps {
                script {
                    echo "Deploying container..."
                    sh """
                        docker stop jenkins-practice-container || true
                        docker rm jenkins-practice-container || true
                    """
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
            cleanWs()
        }
        success {
            echo "🎉 Pipeline executed successfully!"
            echo "📦 Docker image pushed to: ${DOCKER_IMAGE}"
            echo "🌐 Application running at: http://192.168.229.128:${APP_PORT}"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}
