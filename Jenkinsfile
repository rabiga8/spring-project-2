pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS_ID = '5aec70f1-576f-4bbf-8388-65b31ae0113c'
        DOCKER_IMAGE_NAME = 'rabiga8/group-image-2'
    }
    stages {
        
        stage('1. Checkout') {
            steps {
                // Check out the source code from GitHub
                sh "git clone https://github.com/rabiga8/spring-project-2.git"
                sh "git checkout main"
            }
        }

        stage('2. Test') {
            steps {
                withMaven(globalMavenSettingsConfig: '', 
                          jdk: '', maven: 'maven', 
                          mavenSettingsConfig: '', 
                          traceability: true) {
                    sh 'mvn test'
                }
            }
        }

        stage('3.Build Maven') {
            steps {
                withMaven(globalMavenSettingsConfig: '', 
                          jdk: '', maven: 'maven', 
                          mavenSettingsConfig: '', 
                          traceability: true) {
                    sh 'mvn clean package'
                }
            }
            post {
                success {
                    echo "Archiving artifacts"
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

       stage('4. Build Docker Image') {
            steps {
                // Build Docker image
                sh 'docker build -t ${DOCKER_IMAGE_NAME} .'
            }
        }

        stage('5. Dockerhub Login') {
            steps {
                // Authenticate with Docker Hub using credentials
                withCredentials([
                    usernamePassword(
                        credentialsId: DOCKER_CREDENTIALS_ID, 
                        passwordVariable: 'DOCKER_PASSWORD', 
                        usernameVariable: 'DOCKER_USERNAME')
                ]) {
                    sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                }
                    
                // Build Docker image again
                sh 'docker build  -t ${DOCKER_IMAGE_NAME} .'
                    
                // Tag the Docker image with Docker Hub repository name
                sh 'docker tag ${DOCKER_IMAGE_NAME} ${DOCKER_IMAGE_NAME}:latest'
            }
        }


        stage('6. Dockerhub Push') {
            steps {
                // Push Docker image to Docker Hub
                sh 'docker push ${DOCKER_IMAGE_NAME}:latest'
            }
        }
        
        
        stage('7. Code Coverage Report') {
            steps {
                // Publish JaCoCo coverage report
                jacoco(execPattern: 'target/jacoco.exec')
            }
            post {
                always {
                    // Archive artifacts
                    archiveArtifacts(artifacts: 'target/*.war', fingerprint: true)
                }
            }
        }

        
        stage('8. Static Code Analysis') {
            steps {
                withMaven(globalMavenSettingsConfig: '', 
                          jdk: '', maven: 'maven', 
                          mavenSettingsConfig: '', 
                          traceability: true){
                    // Run static code analysis tools
                    sh 'mvn clean compile checkstyle:checkstyle pmd:pmd'
                }
            }
        }
        
        stage('9. Record Issues') {
            steps {
                // Record issues using the specified tools
                recordIssues sourceCodeRetention: 'LAST_BUILD', tools: [
                    checkStyle(),
                    pmdParser(),
                    findBugs(useRankAsPriority: true)
                ]
            }
        }

        stage('10. Deliver Mock') {
            steps {

                withMaven(globalMavenSettingsConfig: '', 
                          jdk: '', maven: 'maven', 
                          mavenSettingsConfig: '', 
                          traceability: true){
                    // sh 'mvn deploy'
                    sh 'echo "Deliver artifact step"'
                }
            }
        }
        
       stage('11. Deploy to Dev Mock') {
            steps {
                sh 'echo "Deploy to Dev step"'
            }
        }
        
        stage('12. Deploy to QAT Mock') {
            steps {
                sh 'echo "Deploy to QAT step"'
            }
        }
        
        stage('13. Deploy to Staging Mock') {
            steps {
                sh 'echo "Deploy to Staging step"'
            }
        }
        
        stage('14. Deploy to Production Mock') {
            steps {
                sh 'echo "Deploy to Production step"'
            }
        }
    }
}
