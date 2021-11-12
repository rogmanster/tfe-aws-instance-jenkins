pipeline {
  agent any

  environment {
      TFE_TOKEN = credentials('tfe_token')
  }

  stages {
      stage ('Check Terraform Version') {
         steps {
           script {
             def tfHome = tool name: 'terraform-0.12.26'
             env.PATH = "${tfHome}:${env.PATH}"
           }

           sh '''
           curl -s -o terraform.zip https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip ; yes | unzip terraform.zip
           echo $PATH
           terraform --version
           '''
         }
      }

      stage ('Create Remote Backend'){
          steps {
            withCredentials([string(credentialsId: 'tfe_token', variable: 'TFE_TOKEN')]) {
            sh '''
            cat <<EOF > remote.tf

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "rogercorp"
    token        = "${TFE_TOKEN}"

    workspaces {
        name = "aws-instance-jenkins"
    }
  }
}
EOF
              '''
            }
          }
      }

      stage ('Terraform Init') {
          steps {
            sh 'pwd'
            sh 'ls -ls'
            cat remote.tf
            sh 'terraform init'
          }
      }

      stage ('Terraform Apply') {
          steps {
            sh 'terraform apply -input=false --auto-approve'
          }
      }

  }
}
