pipeline{
    agent{label 'slave_static'}
    tools {
        maven 'M3'
    }
    stages{
        stage('Checkout'){
            steps{
                git branch: 'main', url: 'https://github.com/LiliiaKoloda/spring-petclinic.git'
            }
            post{
                changed{
                    mail to: "lilia.koloda14@gmail.com",
                    subject: "jenkins checkout:${currentBuild.currentResult}: ${env.JOB_NAME}",
                    body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}"
                }
            }
        }
        stage('Build'){
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
        stage('Test'){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonarqubetoken') {
                            sh 'chmod +x gradlew'
                            sh './gradlew sonarqube'
                    }
                }
            }
            post{
                changed{
                    mail to: "lilia.koloda14@gmail.com",
                    subject: "jenkins test:${currentBuild.currentResult}: ${env.JOB_NAME}",
                    body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}"
                }
            }
        }
        stage('Clean'){
            steps{
                sh 'mvn clean'
            }
            post{
                changed{
                    mail to: "lilia.koloda14@gmail.com",
                    subject: "jenkins package:${currentBuild.currentResult}: ${env.JOB_NAME}",
                    body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}"
                }
            }
        }
        stage('Docker build&push image'){
            steps{
                sh 'docker build -t liliiakoloda/petclinic .'
                sh 'docker login -u liliiakoloda -p Kristina3075!'
                sh 'docker push liliiakoloda/petclinic'
            }
            post{
                changed{
                    mail to: "lilia.koloda14@gmail.com",
                    subject: "jenkins Docker build&push image:${currentBuild.currentResult}: ${env.JOB_NAME}",
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
}
