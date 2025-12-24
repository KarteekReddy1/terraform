pipeline {
    agent any

    environment {
        AWS_CREDS = credentials('ec2-user')  // FIXED: AWS Credentials ID
    }

    parameters {
        choice(name: 'WORKSPACE', choices: ['none', 'dev', 'staging', 'prod'], description: 'Select Terraform workspace')
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose Terraform action')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/KarteekReddy1/terraform.git'
            }
        }

        stage('Terraform Init') {
            when {
                expression { return params.WORKSPACE != 'none' }
            }
            steps {
                sh '''
                  export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
                  export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW
                  terraform init
                '''
            }
        }

        stage('Select Workspace') {
            when {
                expression { return params.WORKSPACE != 'none' }
            }
            steps {
                sh '''
                  export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
                  export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW
                  terraform workspace select ${WORKSPACE} || terraform workspace new ${WORKSPACE}
                '''
            }
        }

        stage('Terraform Plan') {
            when {
                expression { return params.WORKSPACE != 'none' }
            }
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
                allOf {
                    expression { return params.WORKSPACE != 'none' }
                    expression { return params.ACTION == 'apply' }
                }
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
                allOf {
                    expression { return params.WORKSPACE != 'none' }
                    expression { return params.ACTION == 'destroy' }
                }
            }
            steps {
                sh '''
                  export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
                  export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW
                  terraform workspace select ${WORKSPACE}
                  terraform destroy -auto-approve
                '''
            }
        }
    }
}
