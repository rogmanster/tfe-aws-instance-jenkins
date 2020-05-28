pipeline {
  agent any
  tools {
      "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform"
  }
stages {
  stage('Remote Stanza') {
      steps {
        withCredentials([string(credentialsId: 'tfe_token', variable: 'TFE_TOKEN')]) {

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
    }
   }
  }
 }
}
