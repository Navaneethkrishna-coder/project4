
pipeline {
    agent any

    environment {
        DOCKER_IMAGE ='ayanshaji/project4'
    }

    stages {

        stage('Git Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ayanshaji/project4.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=project4 \
                        -Dsonar.projectName=project4 \
                        -Dsonar.sources=project4
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-cred',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login \
                        -u "$DOCKER_USER" --password-stdin

                        docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}

                        docker logout
                    '''
                }
            }
        }

        stage('Git Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'github-cred',
                        usernameVariable: 'GIT_USER',
                        passwordVariable: 'GIT_TOKEN'
                    )
                ]) {
                    sh '''
                        git config user.name "Jenkins"
                        git config user.email "jenkins@example.com"

                        git add -A

                        git diff --cached --quiet || \
                        git commit -m "Updated by Jenkins Build ${BUILD_NUMBER}"

                        git push https://${GIT_USER}:${GIT_TOKEN}@github.com/ayanshaji/project4.git HEAD:main
                    '''
                }
            }
        }
    }
}
