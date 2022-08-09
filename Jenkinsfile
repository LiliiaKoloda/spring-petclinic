pipeline{
    agent{label 'slave_static'}
    tools {
        jdk 'JAVA9'
        maven 'M3'
    }
    stages{
        stage('Checkout'){
            steps{
                git branch: 'main', url: 'https://github.com/LiliiaKoloda/spring-petclinic.git'
                sh 'pwd'
            }
            post{
                changed{
                    mail to: "lilia.koloda14@gmail.com",
                    subject: "jenkins build:${currentBuild.currentResult}: ${env.JOB_NAME}",
                    body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}"
                }
            }
        }
        stage('Build'){
            steps{
                sh 'mvn compile'
            }
            post{
                changed{
                    mail to: "lilia.koloda14@gmail.com",
                    subject: "jenkins build:${currentBuild.currentResult}: ${env.JOB_NAME}",
                    body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}"
                }
            }
        }
        stage('Test'){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonarqubetoken') {
                            sh 'chmod +x gradlew'
                            sh './gradlew sonarqube'
                    }

                    timeout(time: 1, unit: 'HOURS') {
                      def qg = waitForQualityGate()
                      if (qg.status != 'OK') {
                           error "Pipeline aborted due to quality gate failure: ${qg.status}"
                      }
                    } 
                }
            }
            post{
                changed{
                    mail to: "lilia.koloda14@gmail.com",
                    subject: "jenkins build:${currentBuild.currentResult}: ${env.JOB_NAME}",
                    body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}"
                }
            }
        }
        stage('Package'){
            steps{
                sh 'mvn package'
            }
            post{
                changed{
                    mail to: "lilia.koloda14@gmail.com",
                    subject: "jenkins build:${currentBuild.currentResult}: ${env.JOB_NAME}",
                    body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}"
                }
            }
        }
        stage('Docker build&push image'){
            steps{
                sh 'docker build -t jenkins-usera/petclinic .'
                sh 'docker login -u jenkins-user -p 1 54.205.27.58:8083'
                sh 'docker push jenkins-usera/petclinic'
            }
            post{
                changed{
                    mail to: "lilia.koloda14@gmail.com",
                    subject: "jenkins build:${currentBuild.currentResult}: ${env.JOB_NAME}",
                    body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}"
                }
            }
        }
        stage('Deploying application on EKS cluster'){
            steps {
                script {
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'K8S', namespace: '', serverUrl: '') {
                    sh "kubectl apply -f eks-deploy-from-ecr.yaml"
                }
            }
        }
    }
}
