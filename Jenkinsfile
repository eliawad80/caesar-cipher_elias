pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh './gradlew clean build'
            }
        }
        
        stage('Test') {
            steps {
                sh './gradlew test'
            }
        }
        
        stage('Package') {
            steps {
                sh './gradlew assemble'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t caeser .'
            }
        }
        
        stage('Push to GitHub Packages') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: '5237ad31-7aa1-4fb2-9d7b-d8ce8734718f', keyFileVariable: 'SSH_KEY')]) {
                    sh 'docker tag my-image docker.pkg.github.com/eliawad80/caesar-cipher_elias/caeser:latest'
                    sh 'docker login docker.pkg.github.com -u eliawad80 -p $SSH_KEY'
                    sh 'docker push docker.pkg.github.com/eliawad80/caesar-cipher_elias/caeser:latest'
            }
       }
  }
}
}
