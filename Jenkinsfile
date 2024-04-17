pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git 'http://3.88.191.128:3000/haitham/haitham-automation.git'
            }
        }
        stage('Install Nginx') {
            steps {
                script {
                    sh "ansible-playbook InstallNginx.yml --become"
                }
            }
        }
        stage('Create users file') {
            steps {
                script {
                    sh "ansible-playbook getUsers.yml "
                }
            }
        }
    }
    post {
        always {
            emailext(
                attachmentsPattern: '**/*.txt',
                subject: "Pipeline status: ${currentBuild.result}", 
                body: """<html> 
                            <body> 
                                <p> Build Number: ${BUILD_NUMBER} </p> 
                                <p> Date and time of pipeline execution: ${BUILD_TIMESTAMP} </p>
                            </body> 
                            </html>""", 
                to: "haithamelabd@outlook.com", 
                from: "jenkins@haitham.com", 
                replyTo: "jenkins@haitham.com",
                mimeType: "text/html"
            )
        }
    }
}
