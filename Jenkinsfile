pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS_ID = '5aec70f1-576f-4bbf-8388-65b31ae0113c'
        DOCKER_IMAGE_NAME = 'rabiga8/group-image-2'
    }
    stages {
        stage('Checkout') {
            steps {
                // Check out the source code from GitHub
                sh "git clone https://github.com/rabiga8/spring-project-2.git"
                sh "git checkout main"
            }
        }

        // Uncomment and customize stages as needed
        /*
        stage('Test') {
            steps {
                withMaven(globalMavenSettingsConfig: '', 
                          jdk: '', maven: 'maven', 
                          mavenSettingsConfig: '', 
                          traceability: true) {
                    sh 'mvn test'
                }
            }
        }

        stage('Code coverage analysis') {
            steps {
                withMaven(globalMavenSettingsConfig: '', 
                          jdk: '', maven: 'maven', 
                          mavenSettingsConfig: '', 
                          traceability: true) {
                    sh 'mvn clean verify'
                }
            }
        }

        stage('Code static analysis') {
            steps {
                withMaven(globalMavenSettingsConfig: '', 
                          jdk: '', maven: 'maven', 
                          mavenSettingsConfig: '', 
                          traceability: true) {
                    sh 'mvn checkstyle:checkstyle'
                }
            }
        }
        */

        stage('Build Maven') {
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

        stage('Deploy to Tomcat') {
            steps {
                // Deploy the WAR file to Tomcat
                script {
                    def tomcatUrl = 'http://localhost:9999'
                    def warFileName = sh(script: 'ls target/*.war', returnStdout: true).trim()
                    def credentialsId = 'tomcat-credentials'
                    
                    tomcatDeploy adapter: [credentialsId: credentialsId, url: tomcatUrl], war: warFileName
                }
            }
        }

        // Uncomment and customize stages as needed
        /*
        stage('Build Docker Image') {
            steps {
                // Build Docker image
                sh 'docker build -t ${DOCKER_IMAGE_NAME} .'
            }
        }

        stage('Dockerhub Login') {
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

        stage('Deploy to Tomcat') {
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

        stage('Dockerhub Push') {
            steps {
                // Push Docker image to Docker Hub
                sh 'docker push ${DOCKER_IMAGE_NAME}:latest'
            }
        }
        */
    }
}
