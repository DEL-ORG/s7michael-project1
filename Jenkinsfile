pipeline {
    agent any
    parameters {
        string(defaultValue: 'main', name: 'BRANCH')
        string(defaultValue: '', name: 'PORT')
    }
    environment {
        DOCKER_IMAGE = "michaelayo/jenkinsproject1"
    }
    stages {
        stage('check out') {
            steps {
                git branch: params.BRANCH, changelog: false, poll: false, url: 'https://github.com/DEL-ORG/s7michael-project1.git'
            }
        }
        stage('build and test image') {
            steps {
                script {
                    sh """
                    docker build -t "${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}" .
                    docker images
                    docker run -d -p ${params.PORT}:3000 "${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                    docker ps
                    """
                }
            }
        }
        stage('login and push') {
            steps {
                withCredentials([string(credentialsId: 'michael_dockerhub_token', variable: 'dockerhub_credential')]) {
                    sh """
                    docker login -u michaelayo -p $dockerhub_credential
                    docker push "${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                    """
                }
            }
        }
        stage('deploy to kubernetes') {
            steps {
                    // Apply the deployment and service files
                    withCredentials([string(credentialsId: 'k8s-token-cred', variable: 'KUBECONFIG')]) {
                        sh 'kubectl apply -f halo-deployment.yaml --token=$KUBECONFIG'
                        sh 'kubectl apply -f halo-service.yaml --token=$KUBECONFIG'
                    }

            }
        }
    }
}
