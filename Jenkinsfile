pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "ehtasham/jenkins-practice:${env.BUILD_NUMBER}"
        DOCKER_REGISTRY = "docker.io" // Change if using different registry
    }
    
    stages {
        stage('Clone') {
            steps {
                git branch: 'main',
                url: 'https://github.com/M-Ehtasham/jenkins-practice.git',
                credentialsId: '' // Add your credentials ID if private repo
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    // Test if the container starts properly
                    docker.image("${DOCKER_IMAGE}").withRun('-p 8080:80') { c ->
                        sh 'sleep 10' // Wait for container to start
                        // Add curl test to verify the website is working
                        sh 'curl -f http://localhost:8080 || exit 1'
                    }
                }
            }
        }
        
        stage('Push to Registry') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'dockerhub-credentials') {
                        docker.image("${DOCKER_IMAGE}").push()
                        // Also push as latest
                        docker.image("${DOCKER_IMAGE}").push('latest')
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    // Stop and remove existing container
                    sh 'docker stop jenkins-practice-container || true'
                    sh 'docker rm jenkins-practice-container || true'
                    
                    // Run new container
                    sh "docker run -d -p 8080:80 --name jenkins-practice-container ${DOCKER_IMAGE}"
                }
            }
        }
    }
    
    post {
        always {
            // Clean up workspace
            cleanWs()
            
            // Stop test container if still running
            sh 'docker stop test-container || true'
            sh 'docker rm test-container || true'
        }
        success {
            echo '✅ Pipeline completed successfully!'
            echo "🚀 Application deployed at: http://your-server:8080"
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
