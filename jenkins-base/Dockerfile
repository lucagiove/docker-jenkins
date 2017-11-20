FROM jenkins/jenkins:lts
ENV VIRTUAL_HOST jenkins-base
ENV JENKINS_SSL_SUBJ /C=IT/ST=Italy/L=Milan/O=Company/OU=Department/CN=${VIRTUAL_HOST}

# if we want to install via apt
USER root
RUN apt-get update && apt-get install -y    python-dev \
                                            python-pip && \
    rm -rf /var/lib/apt/lists/*

# Python libraries
COPY pip-requirements.txt /tmp/
RUN pip install -r /tmp/pip-requirements.txt && rm /tmp/pip-requirements.txt

# Copy the ssh keys to get code from git
RUN mkdir -p /tmp/ssh/
COPY ssh/id_rsa /tmp/ssh/
RUN chmod 600 /tmp/ssh/id_rsa

# Allows usage of ssh certificates, add the signature and then:
# clone, install and clean the python libraries
# RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
#     eval $(ssh-agent) && \
#     ssh-add /tmp/ssh/id_rsa && \
#     git clone ssh://git@git.domain.com/repository/repository.git --depth 1 -b release/xxx /tmp/repository && \
#     cd /tmp/repository/ && python setup.py install && cd - && rm -Rf /tmp/repository/


# Dedicated volume to store https certificates
RUN mkdir -p /mnt/certs && chown -R jenkins:jenkins /mnt/certs
VOLUME /mnt/certs

# Install the entry-point jenkins wrapper script
COPY jenkins-base.sh /usr/local/bin/jenkins-base.sh
RUN chmod a+x /usr/local/bin/jenkins-base.sh

# drop back to the regular jenkins user - good practice
USER jenkins

# install plugins
COPY jenkins-plugins.txt /tmp/jenkins-plugins.txt
RUN /usr/local/bin/install-plugins.sh < /tmp/jenkins-plugins.txt

# execute the groovy to init the system and the dsl
COPY groovy/init.groovy /usr/share/jenkins/ref/init.groovy.d/init.groovy
COPY groovy/dsl-jobs.groovy /usr/share/jenkins/ref/dsl-jobs.groovy

# copies the extra files in place to be moved in JENKINS_HOME
COPY files/* /usr/share/jenkins/ref/

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins-base.sh"]
