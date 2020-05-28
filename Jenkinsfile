// Jenkinsfile
String credentialsId = 'tfe_token'

try {
  stage('checkout') {
    node {
      cleanWs()
      checkout scm
    }
  }

  // Run terraform init
  stage('init') {
    node {
      withCredentials([string(
        credentialsId: 'tfe_token',
        variable: 'TFE_TOKEN'
      )]) {
      //withCredentials([[
      //  credentialsId: credentialsId,
      //  accessKeyVariable: TFE_TOKEN
      //]]) {
        ansiColor('xterm') {
          sh '''
            set +x

            ##Fetch Terraform
            ##curl -s -o terraform.zip https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip ; yes | unzip terraform.zip

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
EOF
           ##Terraform Init
           terraform init

           '''

        }
      }
    }
  }

  // Run terraform plan
  stage('plan') {
    node {
      withCredentials([[
        $class: 'AmazonWebServicesCredentialsBinding',
        credentialsId: credentialsId,
        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
      ]]) {
        ansiColor('xterm') {
          sh 'terraform plan'
        }
      }
    }
  }

  if (env.BRANCH_NAME == 'master') {

    // Run terraform apply
    stage('apply') {
      node {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: credentialsId,
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          ansiColor('xterm') {
            sh 'terraform apply -auto-approve'
          }
        }
      }
    }

    // Run terraform show
    stage('show') {
      node {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: credentialsId,
          accessKeyVariable: 'AWS_ACCESS_KEY_ID',
          secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
          ansiColor('xterm') {
            sh 'terraform show'
          }
        }
      }
    }
  }
  currentBuild.result = 'SUCCESS'
}
catch (org.jenkinsci.plugins.workflow.steps.FlowInterruptedException flowError) {
  currentBuild.result = 'ABORTED'
}
catch (err) {
  currentBuild.result = 'FAILURE'
  throw err
}
finally {
  if (currentBuild.result == 'SUCCESS') {
    currentBuild.result = 'SUCCESS'
  }
}
