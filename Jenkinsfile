@Library("myshared") _

def arrayStr = []
def testFunc(String name) {
    println "Hello, " + name
}
def baseCommit
def lastCommit
//def fpRepoBranch = "inside_root_fp1_few_fp"

pipeline {
  agent { label 'linux-agent' }
  parameters {
    booleanParam(name: 'PARAM_ALL_FP', defaultValue: false, description: 'Parameter to decide how much FPs to build')
    string(name: 'TIMER', defaultValue: '5', description: 'Timer parameter for pause stage')
    string(name: 'fpRepoBranch', defaultValue: 'inside_root_fp1_few_fp', description: 'Branch parameter')
  }
  stages {
    stage('get variables') {
      steps {
//        script {
//baseCommit = sh(script: "git rev-parse origin/" + env.BRANCH_NAME, returnStdout: true).trim()
//        }
    echo "env.Branch = ${env.BRANCH}"
//  echo "BRANCH_NAME = ${BRANCH_NAME}"
    echo "env.BRANCH_NAME = ${env.BRANCH_NAME}"
    echo "env.GIT_BRANCH = ${env.GIT_BRANCH}"
    echo "env.CHANGE_TARGET = ${env.CHANGE_TARGET}"
    echo "env.CHANGE_BRANCH = ${env.CHANGE_BRANCH}"
    echo "env.CHANGE_ID = ${env.CHANGE_ID}"
    sh '''
    echo "in shell"
    echo "BRANCH_NAME = ${BRANCH_NAME}"
    echo "GIT_BRANCH = ${GIT_BRANCH}"
    echo "CHANGE_BRANCH = ${CHANGE_BRANCH}"
    echo "FROM_BRANCH = ${FROM_BRANCH}"
    echo "CHANGE_ID = ${CHANGE_ID}"
    echo "CHANGE_BRANCH = ${CHANGE_BRANCH}"
    '''
      }
    }
    stage('get list of FPs') {
      steps {
        dir ('main-repo') {
          git branch: 'main', url: 'https://github.com/Workingtechman/jenkins-pipeline.git'
          script {
            echo 'set baseCommit var and env.baseCommit'
            baseCommit = sh(script: "cat last_successful_build.txt", returnStdout: true).trim()
            env.baseCommit = "${baseCommit}"
          }
        }
//        git branch: 'inside_root_fp1_few_fp', url: 'https://github.com/Workingtechman/jenkins.git'
        checkout changelog: false, poll: false, scm: scmGit(branches: [[name: "${params.fpRepoBranch}"]], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Workingtechman/jenkins.git']])
        script {
          echo 'set lastCommit var and env.lastCommit'
          lastCommit = sh(script: "git rev-parse origin/" + params.fpRepoBranch, returnStdout: true).trim()
          env.lastCommit = "${lastCommit}"
          sh 'echo "baseCommit is ${baseCommit} and lastCommit is ${lastCommit}"'
          if ( params.PARAM_ALL_FP ) {
            echo "true - PARAM_ALL_FP is ${PARAM_ALL_FP}"
            map = ["cpvb": runParallelFunc("cpvb"), "detection": runParallelFunc("detection"), "intersect": runParallelFunc("intersect"), "main": runParallelFunc("main"), "stvb": runParallelFunc("stvb"), "profile": runParallelFunc("profile")]
            map.each{entry -> println "$entry.key"}
          }
          else {
            echo "false - PARAM_ALL_FP is ${PARAM_ALL_FP}"
            def folders = sh(script: 'bash ./main-repo/script.bash', returnStdout: true).trim()
            echo "folders is ${folders}"
            if ( "${folders}" == "ui-kit" ) {
              echo "ui-kit - build all"
              map = ["cpvb": runParallelFunc("cpvb"), "detection": runParallelFunc("detection"), "intersect": runParallelFunc("intersect"), "main": runParallelFunc("main"), "stvb": runParallelFunc("stvb"), "profile": runParallelFunc("profile")]
              map.each{entry -> println "$entry.key"}
            }
            else {
              arrayStr = folders.split("\\r?\\n")
              for (i=0; i < arrayStr.size(); i++) {
                if ( arrayStr[i] == "cpvb" || arrayStr[i] == "detection" || arrayStr[i] == "intersect" || arrayStr[i] == "main" || arrayStr[i] == "stvb" ) {
                  echo "i is " + arrayStr[i]
                  echo "Ours FP"
                }
                else {
                  echo "i is " + arrayStr[i]
                  echo "NOT ours FP"
                  return 0
                }
              }
              echo "arrayStr"
              println arrayStr
              echo "runArrayFunc"
              runArrayFunc(arrayStr)
              echo "create map from arrastr.collectEntries"
              map = arrayStr.collectEntries { [it, runParallelFunc(it) ] }
              
//              map.each{entry -> println "$entry.key: $entry.value"}
//              echo "println map"
//              println map
//              echo "println of * is module"
//              println "stvb is module - " + map["stvb"]
//              println "main is module - " + map.main
//              echo "runMapFunc"
//              runMapFunc(map)
              
              echo "testFunc in this pipeline"
              testFunc("Evgen")
            }
          }
        }
      }
    }
    stage('pause'){
      steps {
        echo "this stage pause for ${TIMER} sec"
        sh "sleep ${TIMER}"
      }
}
    stage('paralleling') {
      steps {
        script {
          echo "run parallel"
          parallel(map)
        }
      }
    }
  }
}

