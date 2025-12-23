pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Replace with your repo URL
                git branch: 'master', url: 'https://github.com/KarteekReddy1/terraform.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withAWS(credentials: 'ec2-user', region: 'us-east-1') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withAWS(credentials: 'ec2-user', region: 'us-east-1') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withAWS(credentials: 'ec2-user', region: 'us-east-1') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}