@Library('shared-library@dev') _
import org.jenkins.pipeline.ci.environmentsvar

pipeline {
    agent { label 'jenkins-slave-shared-python3-docker' }
    environment {
        environment_type = getIPIdent()
        ecr_account_id = getECRAccountID()
        region_name = getRegionName(environment_type)
        service_name = "sql-mcp-server"
        COMMIT_ID = sh(script: 'git rev-parse --short HEAD',returnStdout: true).trim()
        BRANCH_NAME = sh(script: 'if [ $GIT_BRANCH != "dev" ];then BRANCH="`echo $GIT_BRANCH|sed \'s@/@-@g\'`";echo $BRANCH;else echo $GIT_BRANCH;fi;',returnStdout: true).trim()
        IMAGE_TAG = "${BRANCH_NAME}_${BUILD_NUMBER}_${COMMIT_ID}"
        bucket_name = "${env.environment_type == "main" ? "bucket-proxymity-lambda-functions" : "bucket-proxymity-lambda-functions-dr"}"
    }

    stages {
        stage('Create docker image'){
            steps {
                script {
                    sh '''
                    echo print Dockerfile
                    cat Dockerfile
                    echo Build started on `date`
                    echo Building the Docker image...

                    aws ecr get-login-password --region ${region_name} | docker login --username AWS --password-stdin ${ecr_account_id}.dkr.ecr.${region_name}.amazonaws.com
                    docker build -f Dockerfile -t ${ecr_account_id}.dkr.ecr.${region_name}.amazonaws.com/${service_name}:${IMAGE_TAG} .
                    echo Pushing the Docker image to ECR on shared-services account
                    docker push ${ecr_account_id}.dkr.ecr.${region_name}.amazonaws.com/${service_name}:${IMAGE_TAG}

                    echo Scan image started on `date`
                    aws ecr start-image-scan --repository-name ${service_name}  --image-id imageTag=${IMAGE_TAG} --region ${region_name}
                    sleep 15
                    aws ecr describe-image-scan-findings --repository-name ${service_name}  --image-id imageTag=${IMAGE_TAG} --region ${region_name}  --output json > testScan.json
                    aws s3 cp testScan.json s3://bucket-proxymity-image-scanning/${service_name}/Scan-${IMAGE_TAG}.json
                '''
                }
            }
        }
    }
}