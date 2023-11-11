pipeline {
    agent any
    environment {
		JOB = 'TechscrumInfra'
		JOB_URL = 'http://localhost:8080/job/TechscrumInfra/'
    }
    stages {
        stage('Checkout') {
            steps {
                git(branch: 'jenkins', credentialsId: 'jenkins_node', url: 'git@github.com:DevOpsTechscrum/DevOps-Techscrum.be.git')
            }
        }
    }
    post {
        always {
            script {
                checkAndTriggerDownstreamJobs()
            }
        }
    if (frontendChanged) {
        build job: 'techscrum-frontend-terraform-pipeline', wait: true
    }

    if (backendChanged) {
        build job: 'Backend-terraform', wait: true
    }

    if (monitorChanged) {
        build job: 'opensearch_and_monitor', wait: true
    }
}