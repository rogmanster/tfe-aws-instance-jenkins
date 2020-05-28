pipeline {
  agent any
  tools {
      "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform"
  }
stages {
  stage('Integration Tests') {
      steps {
      //sh 'curl -s -o vault.zip https://releases.hashicorp.com/vault/1.4.0/vault_1.4.0_linux_amd64.zip ; yes | unzip vault.zip'
        withCredentials([string(credentialsId: 'tfe_token', variable: 'TFE_TOKEN'))]) {
        sh '''
    set +x
    ## ENV
    ## export VAULT_ADDR=${VAULT_ADDR}
    ## export VAULT_TOKEN=${VAULT_TOKEN}

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

    ## Terraform Init
    terraform init
          '''
    }
   }
  }
 }
}
