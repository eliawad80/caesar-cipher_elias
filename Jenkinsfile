//Jenkins pipeline to test, build, deploy and release 
pipeline {
    //Defining where the pipeline will execute. Can be a top-level agent like this or a stage level agent. It is set to any to execute in any of the available nodes
    agent any
    stages {
        //Execute the command for test phase. Inorder to compile the source code and test code and then execute the tests.
        stage ('Test') {
            steps {
                sh './gradlew test'
            }
        }
        //Build and package the project
        stage ('Build') {
            steps {
                sh './gradlew build'
            }
        }
        //Outputs the result of the final build - Optional. Deploy is usually the stage of deploying the released version of a 
        //project into the desired environment, usually production environment
        stage ('Deploy/Show Output'){
            steps {
                echo 'Deploying/Outputing .....'
                sh 'java -jar build/libs/caesar-cipher.jar'
            }  
        }
        //Releasing the build version of the project into repo 
        stage ('Release') {
            steps {

                withCredentials([string(credentialsId: 'my_github_token', variable: 'GITHUB_TOKEN')])
                {
        
                script {
                    //Retrieveing the latest git version tag and assiging it to the variable TAG
                    TAG = sh (
                    script: 'git describe --tags | awk -F - \'{print $1}\'',
                    returnStdout: true).trim()
                    echo "Tag value: ${TAG}"
                    //Pushing the release to github repo using github api and extracting the Id value of the release and assiging it to the variable RELEASE.
                    RELEASE = sh (script: """
                    curl -X POST \
                        -H "Authorization: token ${GITHUB_TOKEN}" \
                        -d '{"tag_name": "${TAG}","target_commitish": "main","name": "Release Initial","body": "First release","draft": false,"prerelease": false}' "https://api.github.com/repos/nityapisharodi/caesar-cipher/releases"|jq -r .id
                        """,
                    returnStdout: true).trim()
                    echo "Release value: ${RELEASE}"
                    // Pushing the build file into the latest release (Identified by the Id value assigned to the variable RELEASE).
                    // Uses uploads api of github
                    sh (script: """
                    curl -s -X POST \
                            -H "Authorization: token ${GITHUB_TOKEN}" \
                            --header "Content-Type: application/octet-stream" \
                            --data-binary @"build/libs/caesar-cipher.jar" https://uploads.github.com/repos/nityapisharodi/caesar-cipher/releases/${RELEASE}/assets?name=caesar-cipher.jar
                        """,
                    returnStdout: false)   

                    
                }
                   
                }
            }
        }
                
    }
    //Post build activity of Jenkins to archive the artifacts
    post {
        always {
            archiveArtifacts artifacts: 'build/libs/caesar-cipher.jar', onlyIfSuccessful: true
        }
    }
        
   }
   
