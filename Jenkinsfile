pipeline {
    agent any
    environment {
        IMAGE_NAME = "harper1105/myapp"
        BUILD_TAG = "v${BUILD_NUMBER}"
    }
    stages {
        stage('Init') {
            steps {
                script {
                    // Create namespace based on branch
                    if (env.BRANCH_NAME == 'main') {
                        echo "Creating Prod Namespace"
                        sh 'kubectl create ns prod || echo "------- Prod Namespace Already Exists -------"'
                    } else if (env.BRANCH_NAME == 'dev') {
                        echo "Creating Dev Namespace"
                        sh 'kubectl create ns dev || echo "------- Dev Namespace Already Exists -------"'
                    } else {
                        echo "Unrecognized branch"
                    }
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    // Build Docker image
                    echo "Building Docker image for branch: ${env.BRANCH_NAME}"
                    sh """
                    docker build -t ${IMAGE_NAME}:latest -t ${IMAGE_NAME}:${BUILD_TAG} .
                    """
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    // Push Docker image to Docker Hub
                    echo "Pushing Docker image for branch: ${env.BRANCH_NAME}"
                    sh """
                    docker push ${IMAGE_NAME}:latest
                    docker push ${IMAGE_NAME}:${BUILD_TAG}
                    """
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Deploy to the respective namespace
                    if (env.BRANCH_NAME == 'main') {
                        echo "Deploying to Prod"
                        sh """
                        kubectl apply -f ./K8s -n prod
                        kubectl set image deployment/flask-deployment flask-container=${IMAGE_NAME}:${BUILD_TAG} -n prod
                        """
                    } else if (env.BRANCH_NAME == 'dev') {
                        echo "Deploying to Dev"
                        sh """
                        kubectl apply -f ./K8s -n dev
                        kubectl set image deployment/flask-deployment flask-container=${IMAGE_NAME}:${BUILD_TAG} -n dev
                        """
                    } else {
                        echo "Unrecognized branch"
                    }
                }
            }
        }
    }
}
