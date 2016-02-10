# Define Brooklyn and package versions

Name:           apache-brooklyn
Version:        <set_version>
Release:        <set_release>
Summary:        The Apache Brooklyn program from brooklyn.apache.org

Group:          Applications/Internet
License:        ASL 2.0
URL:            https://brooklyn.apache.org/
Requires:       java

%description
Apache Brooklyn is a framework for modeling, monitoring, and managing applications through autonomic blueprints.

# Set up a group and a user to run the service
%pre
/bin/getent group brooklyn || /sbin/groupadd -r brooklyn
/bin/getent passwd brooklyn || /sbin/useradd -r -g brooklyn -d /opt/brooklyn -s /sbin/nologin brooklyn

# Set the files ownership
%post
/bin/chmod 600 /etc/brooklyn/brooklyn.conf
/bin/chmod 644 /etc/brooklyn/logback.xml
/bin/chown -R brooklyn:brooklyn /etc/brooklyn/
/bin/chown -R brooklyn:brooklyn /opt/brooklyn/
/bin/chown -R brooklyn:brooklyn /var/log/brooklyn/

# Reload and start systemd daemon
/bin/systemctl daemon-reload
/bin/systemctl start brooklyn

# Stop service before uninstalling the package
%preun
/bin/systemctl stop brooklyn

# Delete the user
%postun
/sbin/userdel brooklyn
/bin/rm -rf /var/run/brooklyn

# Define dirs for regular files
%files
/opt/brooklyn/
/var/log/brooklyn/

# Define dirs for config files
%config
/etc/brooklyn/
/etc/systemd/system/brooklyn.service

