pipeline {
    agent any

    environment {
        // Bind AWS credentials stored in Jenkins (type: AWS Credentials)
        AWS_CREDS = credentials('ec2-user')
    }

    stages {
        stage('Checkout') {
            steps {
                // Replace with your Git repo URL
                git branch: 'master', url: 'https://github.com/KarteekReddy1/terraform.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                  export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
                  export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW
                  terraform init
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                  export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
                  export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW
                  terraform plan -out=tfplan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                  export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
                  export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW
                  terraform apply -auto-approve tfplan
                '''
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return params.DESTROY == true }
            }
            steps {
                sh '''
                  export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
                  export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW
                  terraform destroy -auto-approve
                '''
            }
        }
    }

    parameters {
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Set true to destroy infra')
    }
}