pipeline {
    agent any

    environment {
        IMAGE = "kyipyar/hellowrold-service:1.0"
        

        STAGE_CONTEXT  = "kind-calculator-stage"
       
    }

    tools {
        maven 'maven3.9'
    }

    stages {

        stage('Checkout Source') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/AyeKyiPyar/hello-k8s.git'
            }
        }

        stage('Build Application') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

       
        stage('Build Docker Image') {
            steps {
                
                sh 'docker build -t $IMAGE .'
                
            }
        }


        stage('Push to Docker Hub') {
		    steps {
		        withCredentials([usernamePassword(
		            credentialsId: 'dockerhub',
		            usernameVariable: 'USER',
		            passwordVariable: 'PASS'
		        )]) {
		            sh 'docker login -u $USER -p $PASS'
		            sh 'docker push kyipyar/hellowrold-service:1.0'
		        }
		    }
		}
		

		stage('Deploy to STAGE') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'kubeconfig-stage',
                        variable: 'KUBECONFIG'
                    )
                ]) {
                    sh '''
					kubectl config use-context kind-calculator-stage
                    kubectl config current-context
            		kubectl apply -f deployment.yaml --server=https://calculator-stage-control-plane:6443 --insecure-skip-tls-verify=true
                   	kubectl apply -f service.yaml --validate=false --insecure-skip-tls-verify=true
                    '''
                }
            }
        }

       stage('Performance Testing') {
            steps {
                sh './performance-test.sh'
            }
        }
    }

    post {

        success {
            echo 'CI/CD Pipeline Completed Successfully!'
        }

        failure {
            echo 'Pipeline Failed!'
        }
    }
}
