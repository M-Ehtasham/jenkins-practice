pipeline {
    agent any
    
    stages {
        stage('Clone and Build') {
            steps {
                git 'https://github.com/M-Ehtasham/jenkins-practice.git'
                
                script {
                    // Build Docker image
                    docker.build('jenkins-practice:latest')
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    // Stop old container if running
                    sh 'docker stop jenkins-practice-app || true'
                    sh 'docker rm jenkins-practice-app || true'
                    
                    // Run new container
                    sh 'docker run -d -p 8080:80 --name jenkins-practice-app jenkins-practice:latest'
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline execution completed'
        }
    }
}
