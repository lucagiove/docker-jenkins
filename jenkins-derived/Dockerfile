FROM jenkins-base

# Python libraries
USER root
COPY pip-requirements.txt /tmp/
RUN pip install -r /tmp/pip-requirements.txt && rm /tmp/pip-requirements.txt

USER jenkins

# install plugins
# UNCOMMENT WHEN THE FILE IS NOT EMPTY
#COPY jenkins-plugins.txt /tmp/jenkins-plugins.txt
#RUN /usr/local/bin/install-plugins.sh < /tmp/jenkins-plugins.txt

# overrides the job initializer
COPY groovy/dsl-jobs.groovy /usr/share/jenkins/ref/dsl-jobs.groovy

# copies the extra files in place to be moved in JENKINS_HOME
# UNCOMMENT WHEN THERE ARE FILES TO COPY
# COPY files/* /usr/share/jenkins/ref/
