pipeline {
    agent any

    environment {
        AWS_CREDS = credentials('ec2-user')
    }

    parameters {
        choice(name: 'WORKSPACE', choices: ['dev', 'staging', 'prod'], description: 'Select Terraform workspace')
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Set true to destroy infra')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/KarteekReddy1/terraform.git'
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

        stage('Select Workspace') {
            steps {
                sh '''
                  export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
                  export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW
                  terraform workspace select ${WORKSPACE} || terraform workspace new ${WORKSPACE}
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
            when {
                expression { return params.DESTROY == false }
            }
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
}
