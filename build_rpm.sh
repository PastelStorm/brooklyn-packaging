#!/bin/bash

set -eu
set -o pipefail

# Check args number
if [ "$#" -ne 1 ]; then
    echo "Usage: $(basename ${0}) <package_release_version>"
    exit 1
fi

NAME="apache-brooklyn"
TOP_DIR="/tmp/brooklyn-buildroot"

PACKAGE_VERSION=${1}
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if tarball exists in tarball/ dir
if [ ! -f ${SCRIPT_DIR}/tarball/apache-brooklyn*.tar.gz ]; then
    echo "Brooklyn tar.gz file not found in ${SCRIPT_DIR}/tarball"
    exit 1
fi

# Check if there is only single tarball inside tarball/ dir
if [ $(ls -al "${SCRIPT_DIR}/tarball" | grep apache-brooklyn*.tar.gz | wc -l) -gt "1" ]; then
    echo "Too many tar.gz files found in ${SCRIPT_DIR}, exiting..."
    exit 1
else
    # Set the brooklyn version
    BROOKLYN_VERSION=$(ls ${SCRIPT_DIR}/tarball/apache-brooklyn*.tar.gz | awk -F'-' '{print $3}')
fi


# Change ~/.rpmmacros topdir value
echo "%_topdir %(echo ${TOP_DIR})/rpmbuild" > ${HOME}/.rpmmacros

# Clean ${TOP_DIR}
rm -rf ${TOP_DIR}

# Uninstall apache-brooklyn if installed
if rpm -qa | grep apache-brooklyn; then
    echo "Please remove the apache-brooklyn package first with \"sudo rpm -e apache-brooklyn\""
    exit 1
fi

# Create rpmbuild directory structure
mkdir -p\
    ${TOP_DIR}/rpmbuild/BUILD\
    ${TOP_DIR}/rpmbuild/BUILDROOT\
    ${TOP_DIR}/rpmbuild/RPMS\
    ${TOP_DIR}/rpmbuild/SOURCES\
    ${TOP_DIR}/rpmbuild/SPECS\
    ${TOP_DIR}/rpmbuild/SRPMS

# Additional directory structure
mkdir -p\
    ${TOP_DIR}/rpmbuild/BUILDROOT/${NAME}-${BROOKLYN_VERSION}-${PACKAGE_VERSION}.x86_64/etc/brooklyn\
    ${TOP_DIR}/rpmbuild/BUILDROOT/${NAME}-${BROOKLYN_VERSION}-${PACKAGE_VERSION}.x86_64/etc/systemd/system\
    ${TOP_DIR}/rpmbuild/BUILDROOT/${NAME}-${BROOKLYN_VERSION}-${PACKAGE_VERSION}.x86_64/var/log/brooklyn\
    ${TOP_DIR}/rpmbuild/BUILDROOT/${NAME}-${BROOKLYN_VERSION}-${PACKAGE_VERSION}.x86_64/opt/brooklyn\

# Unpack tarball into BUILDROOT directory
if [ -f ${SCRIPT_DIR}/tarball/apache-brooklyn*.tar.gz ]; then
    tar xf ${SCRIPT_DIR}/tarball/apache-brooklyn*.tar.gz -C ${TOP_DIR}/rpmbuild/BUILDROOT/${NAME}-${BROOKLYN_VERSION}-${PACKAGE_VERSION}.x86_64/opt/brooklyn/ --strip-components 1
else
    echo "Brooklyn tar.gz file not found in ${SCRIPT_DIR}/tarball"
    exit 1
fi

# Add Brooklyn version and Release version to spec file
sed -e "s/^Version:/Version:\t${BROOKLYN_VERSION}" "${SCRIPT_DIR}/rpm/brooklyn.spec"
sed -e "s/^Release:/Release:\t${PACKAGE_VERSION}" "${SCRIPT_DIR}/rpm/brooklyn.spec"

#TODO Grab changelog data and append to the spec file
echo "%changelog\n- Initial version of the package" >> "${SCRIPT_DIR}/rpm/brooklyn.spec"

# Copy files
cp ${SCRIPT_DIR}/conf/brooklyn.conf ${TOP_DIR}/rpmbuild/BUILDROOT/${NAME}-${BROOKLYN_VERSION}-${PACKAGE_VERSION}.x86_64/etc/brooklyn/
cp ${SCRIPT_DIR}/conf/logback.xml ${TOP_DIR}/rpmbuild/BUILDROOT/${NAME}-${BROOKLYN_VERSION}-${PACKAGE_VERSION}.x86_64/etc/brooklyn/
cp ${SCRIPT_DIR}/rpm/brooklyn.spec ${TOP_DIR}/rpmbuild/SPECS
cp ${SCRIPT_DIR}/daemon/systemd/brooklyn.service ${TOP_DIR}/rpmbuild/BUILDROOT/${NAME}-${BROOKLYN_VERSION}-${PACKAGE_VERSION}.x86_64/etc/systemd/system/

# Ensure correct permissions on files
chmod 600 ${TOP_DIR}/rpmbuild/BUILDROOT/${NAME}-${BROOKLYN_VERSION}-${PACKAGE_VERSION}.x86_64/etc/brooklyn/brooklyn.conf
chmod 644 ${TOP_DIR}/rpmbuild/BUILDROOT/${NAME}-${BROOKLYN_VERSION}-${PACKAGE_VERSION}.x86_64/etc/brooklyn/logback.xml

# Run the build
rpmbuild -ba ${TOP_DIR}/rpmbuild/SPECS/brooklyn.spec
