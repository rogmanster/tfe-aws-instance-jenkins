pipeline {
    agent any
    tools {
        "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform-0.12.26"
    }
    environment {
        //TF_HOME = tool('terraform-0.12.26')
        //TF_IN_AUTOMATION = "true"
        //PATH = "$TF_HOME:$PATH"
        //ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
        //SECRET_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {

          stage('Set Terraform path') {
            steps {
              script {
                def tfHome = tool name: 'terraform-0.12.26'
                env.PATH = "${tfHome}:${env.PATH}"
              }
              sh 'terraform version'

            }
          }

          stage('TerraformInit'){
            steps {
                dir('jenkins-terraform-pipeline/ec2_pipeline/'){
                    sh "terraform init -input=false"
                    sh "echo \$PWD"
                    sh "whoami"
                }
            }
        }
    }
}
