pipeline {
  agent any
  tools {
      "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform-0.12.26"
  }

  environment {
      TFE_TOKEN = credentials('tfe_token')
      TF_HOME = tool('terraform-0.12.26')
      //TF_IN_AUTOMATION = "true"
      PATH = "$TF_HOME:$PATH"
  }

  stages {
    stage('Remote Stanza') {
      steps {
    sh '''
    set +x

    ##Create remote backend file
    cat <<EOF>remote.tf
    terraform {
      backend "remote" {
        hostname     = "https://app.terraform.io/"
        organization = "rogercorp"
        token        = "${TFE_TOKEN}"

        workspaces {
          name = "aws-instance-jenkins"
        }
      }
    }

    cat remote.tf
    pwd
    '''
      } //steps
    } //stage

    stage('TerraformInit'){
      steps {
          dir('ec2_pipeline/'){
              sh "terraform init -input=false"
              //sh "echo \$PWD"
              //sh "whoami"
      } //steps
    } //stage

  } //stages

 }
}
