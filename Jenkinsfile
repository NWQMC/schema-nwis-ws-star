pipeline {
  agent {
    node {
      label 'team:iow'
    }
  }
  stages {
    stage('Set Build Description') {
      steps {
        script {
          currentBuild.description = "Deploy to ${env.DEPLOY_STAGE}"
        }
      }
    }
    stage('Clean Workspace') {
      steps {
        cleanWs()
      }
    }
    stage('Git Clone') {
      steps {
        checkout([
            $class: 'GitSCM',
            branches: [[name: '*/master']],
            doGenerateSubmoduleConfigurations: false,
            extensions: [],
            submoduleCfg: [],
            userRemoteConfigs: [[credentialsId: 'CIDA-Jenkins-GitHub',
            url: 'https://github.com/NWQMC/schema-nwis-ws-star.git']]])
      }
    }
    stage('Download liquibase jar') {
      steps {
        sh '''mkdir $WORKSPACE/nwis
          /usr/local/bin/aws s3 cp s3://owi-common-resources/resources/InstallFiles/liquibase/liquibase-$LIQUIBASE_VERSION.tar.gz $WORKSPACE/nwis/liquibase.tar.gz
          /usr/bin/tar xzf $WORKSPACE/nwis/liquibase.tar.gz --overwrite -C $WORKSPACE/nwis
          /usr/local/bin/aws s3 cp s3://owi-common-resources/resources/InstallFiles/postgres/$JDBC_JAR $WORKSPACE/nwis/lib/$JDBC_JAR
        '''
      }
    }
    stage('Run liquibase') {
      steps {
        script {
          def mappedStage = ""
          def deployStage = '$DEPLOY_STAGE'
          switch(deployStage) {
            case "PROD-EXTERNAL":
              mappedStage = "legacy-production-external"
              break
            case "QA":
              mappedStage = "legacy-qa"
              break
            case "TEST":
              mappedStage = "legacy-test"
              break
            default:
              mappedStage = "development"
          }
          def dbAdminSecret = sh(script: '/usr/local/bin/aws secretsmanager get-secret-value --name "/observations-db-$mappedStage/$mappedStage/rds-admin-password" --region "us-west-2"', returnStdout: true).trim()
          def secretsString = sh(script: '/usr/local/bin/aws ssm get-parameter --name "/aws/reference/secretsmanager/WQP-EXTERNAL-$DEPLOY_STAGE" --query "Parameter.Value" --with-decryption --output text --region "us-west-2"', returnStdout: true).trim()
          def dbAdminSecretJson = readJSON test: dbAdminSecret
          def secretsJson =  readJSON text: secretsString
          env.NWIS_DATABASE_ADDRESS = secretsJson.DATABASE_ADDRESS
          env.NWIS_DATABASE_NAME = secretsJson.DATABASE_NAME
          env.NWIS_DB_OWNER_USERNAME = secretsJson.DB_OWNER_USERNAME
          env.NWIS_DB_OWNER_PASSWORD = secretsJson.DB_OWNER_PASSWORD
          env.NWIS_SCHEMA_NAME = secretsJson.NWIS_SCHEMA_NAME
          env.NWIS_SCHEMA_OWNER_USERNAME = secretsJson.NWIS_SCHEMA_OWNER_USERNAME
          env.NWIS_SCHEMA_OWNER_PASSWORD = secretsJson.NWIS_SCHEMA_OWNER_PASSWORD
          env.WQP_SCHEMA_NAME = secretsJson.WQP_SCHEMA_NAME
          env.WDFN_DB_READ_ONLY_PASSWORD = secretsJson.WDFN_DB_READ_ONLY_PASSWORD
          env.WDFN_DB_READ_ONLY_USERNAME = secretsJson.WDFN_DB_READ_ONLY_USERNAME
          env.WQP_SCHEMA_OWNER_USERNAME = secretsJson.WQP_SCHEMA_OWNER_USERNAME
          env.WQP_SCHEMA_OWNER_PASSWORD = secretsJson.WQP_SCHEMA_OWNER_PASSWORD
          env.POSTGRES_PASSWORD = dbAdminSecretJson.SecretString
          env.OBSERVATION_SCHEMA_NAME = secretsJson.OBSERVATION_SCHEMA_NAME

          sh '''

            export CONTEXTS=$CONTEXTS
            export LIQUIBASE_HOME=$WORKSPACE/nwis
            export LIQUIBASE_WORKSPACE_NWIS=$WORKSPACE/liquibase/changeLogs

            chmod +x $WORKSPACE/liquibase/scripts/z1_postgres_liquibase.sh
            chmod +x $WORKSPACE/liquibase/scripts/z2_nwis_liquibase.sh
            $WORKSPACE/liquibase/scripts/z1_postgres_liquibase.sh
            $WORKSPACE/liquibase/scripts/z2_nwis_liquibase.sh
            '''
        }
      }
    }
  }
}
