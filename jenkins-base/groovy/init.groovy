import hudson.model.*;
import jenkins.model.*;

import javaposse.jobdsl.dsl.DslScriptLoader
import javaposse.jobdsl.plugin.JenkinsJobManagement

// TODO would be nice to have it as variable
Jenkins.instance.setNumExecutors(4)

def jobDslScript = new File('/usr/share/jenkins/ref/dsl-jobs.groovy')
def workspace = new File('.')

def jobManagement = new JenkinsJobManagement(System.out, [:], workspace)

new DslScriptLoader(jobManagement).runScript(jobDslScript.text)
