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
        
        stage('4. Code Coverage Report') {
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

        
        stage('5. Static Code Analysis') {
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


        
        stage('6. Record Issues') {
            steps {
                // Record issues using the specified tools
                recordIssues sourceCodeRetention: 'LAST_BUILD', tools: [
                    checkStyle(),
                    pmdParser(),
                    findBugs(useRankAsPriority: true)
                ]
            }
        }
        

        stage('7. Build Docker Image') {
            steps {
                // Build Docker image
                sh 'docker build -t ${DOCKER_IMAGE_NAME} .'
            }
        }

        stage('8. Dockerhub Login') {
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

        stage('9. Deploy to Tomcat') {
            steps {
                withMaven(globalMavenSettingsConfig: '', 
                          jdk: '', maven: 'maven', 
                          mavenSettingsConfig: '', 
                          traceability: true) {
                    // Add a step for your project’s build tool to release an artifact
                    sh 'mvn deploy'
                }
            }
        }

        stage('10. Dockerhub Push') {
            steps {
                // Push Docker image to Docker Hub
                sh 'docker push ${DOCKER_IMAGE_NAME}:latest'
            }
        }
        

        // stage(' Deliver') {
        //     steps {

        //         withMaven(globalMavenSettingsConfig: '', 
        //                   jdk: '', maven: 'maven', 
        //                   mavenSettingsConfig: '', 
        //                   traceability: true){
        //             sh 'mvn deploy'
        //         }
        //     }
        // }
        
        // stage('Deploy to Dev Env') {
        //     when {
        //         branch 'develop' // Deploy only from the develop branch
        //     }
        //     steps {
        //         sh 'kubectl apply -f dev.yaml' // Example command for Kubernetes deployment
        //     }
        // }
        // stage('Deploy to QAT Env') {
        //     when {
        //         branch 'release/*' // Deploy only from release branches
        //     }
        //     steps {
        //         // Step to deploy artifact to QAT environment
        //         sh 'kubectl apply -f qat.yaml' // Example command for Kubernetes deployment
        //     }
        // }
        // stage('Deploy to Staging Env') {
        //     when {
        //         branch 'staging' // Deploy only from the staging branch
        //     }
        //     steps {
        //         // Step to deploy artifact to Staging environment
        //         sh 'kubectl apply -f staging.yaml' // Example command for Kubernetes deployment
        //     }
        // }
        // stage('Deploy to Production Env') {
        //     when {
        //         branch 'master' // Deploy only from the master branch
        //     }
        //     steps {
        //         // Step to deploy artifact to Production environment
        //         sh 'kubectl apply -f production.yaml' // Example command for Kubernetes deployment
        //     }
        // }

        // stage('Deploy to Tomcat server') {
        //     steps {
        //         deploy adapters: [
        //             tomcat9(
        //                 credentialsId: 'tomcat-credentials',
        //                 path: '',
        //                 url: 'http://localhost:9999/'
        //             )
        //         ], contextPath: null, war: '**/*.war'
        //     }
        // }

        // stage('Deploy to Tomcat') {
        //     steps {
        //         // Deploy the WAR file to Tomcat
        //         script {
        //             def tomcatUrl = 'http://localhost:9999'
        //             def warFileName = sh(script: 'ls target/*.war', returnStdout: true).trim()
        //             def credentialsId = 'tomcat-credentials'
                    
        //             deploy adapters: [tomcat9(credentialsId: credentialsId, url: tomcatUrl)], war: warFileName
        //         }
        //     }
        // }

   
        
        
    }
}
