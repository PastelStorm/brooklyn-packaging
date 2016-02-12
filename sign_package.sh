#!/bin/bash -x

set -eu
set -o pipefail

# Check OS
if [ $(uname -s) == "Darwin" ]; then
    echo "Signing on OS X not supported, skipping..."
    exit 0
elif $(uname -v | grep Ubuntu); then
    echo "Signing on Ubuntu not supported, skipping..."
    exit 0
fi

# Check args number
if [ "$#" -ne 1 ]; then
    echo "Usage: $(basename ${0}) <rpm_sign_password_file>"
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RPM_SIGN_PASSWORD_FILE=${1}

# Check password file permissions
if [ $(stat -c %a ${RPM_SIGN_PASSWORD_FILE}) -gt "600" ]; then
    echo "Permission on file ${RPM_SIGN_PASSWORD_FILE} are too open, exiting..."
    exit 1
fi

# Check if the key is already in rpm database
if ! rpm -q gpg-pubkey --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n' | grep 'Apache Brooklyn Key' > /dev/null; then

    # Check if the key is available in the key directory
    if [ ! -f ${SCRIPT_DIR}/key/RPM-GPG-KEY* ]; then
        echo "Key not found in {SCRIPT_DIR}/key/, exiting"
        exit 1
    fi

    # Move the key to /etc/pki/rpm-gpg dir
    mv ${SCRIPT_DIR}/key/RPM-GPG-KEY* /etc/pki/rpm-gpg/

    # Export the key to rpm database
    rpm --import RPM-GPG-KEY-apache-brooklyn
fi

# Configure rpmmacros to use the correct key for signing
echo "%_signature gpg" >> ~/.rpmmacros
echo "%_gpg_name Apache Brooklyn Key (Apache Brooklyn Official Signing Key) <dev@brooklyn.apache.org>" >> ~/.rpmmacros

# Sign the package, using expect to do unattended signing
expect ${SCRIPT_DIR}/rpm_sign.exp ${SCRIPT_DIR}/package/*rpm ${RPM_SIGN_PASSWORD_FILE}
