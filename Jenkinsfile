pipeline {
    agent any
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
    }
}

@NonCPS
def checkAndTriggerDownstreamJobs() {
    def changeLogSets = currentBuild.changeSets
    def frontendChanged = false
    def backendChanged = false
    def monitorChanged = false

    for (int i = 0; i < changeLogSets.size(); i++) {
        def entries = changeLogSets[i].items
        for (int j = 0; j < entries.length; j++) {
            def entry = entries[j]
            def affectedFiles = entry.affectedFiles
            for (int k = 0; k < affectedFiles.size(); k++) {
                def file = affectedFiles[k]
                if (file.path.contains("FrontendTF")) {
                    frontendChanged = true
                }
                if (file.path.contains("backend")) {
                    backendChanged = true
                }
                if (file.path.contains("opensearch_and_monitor")) {
                    monitorChanged = true
                }
            }
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