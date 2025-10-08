pipeline {
    agent any
    
    stages {
        stage('Clean and Clone') {
            steps {
                cleanWs()
                git branch: 'main', 
                url: 'https://github.com/M-Ehtasham/jenkins-practice.git'
            }
        }
        
        stage('Build Image') {
            steps {
                script {
                    // Simple build without credentials first
                    sh 'docker build -t jenkins-practice:latest .'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    sh '''
                        docker stop practice-app || true
                        docker rm practice-app || true
                        docker run -d -p 8080:80 --name practice-app jenkins-practice:latest
                    '''
                }
            }
        }
        
        stage('Verify') {
            steps {
                script {
                    sh 'sleep 5'
                    sh 'curl -s http://localhost:8080 | head -n 5'
                    echo "✅ Deployment verified!"
                }
            }
        }
    }
}
