pipeline {
  agent any

  tools {
     "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform-0.12.26"
  }

  environment {
      TFE_TOKEN = credentials('tfe_token')
      //TF_HOME = tool('terraform-0.12.26')
      //TF_IN_AUTOMATION = "true"
      //PATH = "$TF_HOME:$PATH"
  }

  stages {
      stage ('Check Terraform Version') {
         steps {
            script {
            def tfhome = tool name: 'terraform-0.12.26', type: 'org.jenkinsci.plugins.terraform.TerraformInstallation'
            env.PATH = "${tfhome}:${env.PATH}"
            sh 'terraform --version'
          }
         }
      }
      stage ('Terraform Initialize & Plan'){
          steps {
            withCredentials([azureServicePrincipal('AzureSPN')]){
            dir(‘dev’)
            sh '''
            terraform init
            terraform plan -input=false -var 'subscription_id='$AZURE_SUBSCRIPTION_ID -var 'client_id='$AZURE_CLIENT_ID -var 'client_secret='$AZURE_CLIENT_SECRET 'tenand_id='$AZURE_TENANT_ID
            '''
            }
          }
      }
      stage ('Terraform Apply') {
          steps {
            sh '''
            terraform apply -input=false --auto-approve
            '''
      }
  }
}
}
