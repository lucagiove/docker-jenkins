#! /bin/bash -e

# Generates the https certificates
if [[ ! (-f "/mnt/certs/${VIRTUAL_HOST}.crt" && -f "/mnt/certs/${VIRTUAL_HOST}.key") ]]; then
   mkdir -p /mnt/certs
   openssl req -x509 -sha256 -nodes -days 3650 -newkey rsa:2048 \
   -subj "${JENKINS_SSL_SUBJ}" \
   -keyout /mnt/certs/${VIRTUAL_HOST}.key \
   -out /mnt/certs/${VIRTUAL_HOST}.crt
fi

# Run the original jenkins ENTRYPOINT
/usr/local/bin/jenkins.sh
