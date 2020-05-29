pipeline {
  agent any

  environment {
      TFE_TOKEN = credentials('tfe_token')
      //TF_HOME = tool('terraform-0.12.26')
      //TF_IN_AUTOMATION = "true"
      //PATH = "$TF_HOME:$PATH"
  }

  stages {
      stage ('Check Terraform Version') {
         steps {
           pwd
           echo $PATH
           ls
           sh 'curl -s -o terraform.zip https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip ; yes | unzip terraform.zip'
           sh 'terraform --version'
           sh 'ls'
           sh 'pwd'
         }
      }
      stage ('Create Remote Backend'){
          steps {
            withCredentials([string(credentialsId: 'tfe_token', variable: 'TFE_TOKEN')]) {
            sh '''
            cat <<EOF > remote.tf

  terraform {
     backend "remote" {
       hostname     = "https://app.terraform.io"
       organization = "rogercorp"
       token        = "${TFE_TOKEN}"

       workspaces {
           name = "aws-instance-jenkins"
       }
     }
   }

   ls
   pwd

              '''
            }
          }
      }

      stage ('Terraform Apply') {
          steps {
            sh 'terraform apply -input=false --auto-approve'
          }
      }
  }
}
