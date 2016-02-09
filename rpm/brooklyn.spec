# Define Brooklyn and package versions
%define brooklyn_version 0.8.0
%define package_version 1

Name:           apache-brooklyn
Version:        %brooklyn_version
Release:        %package_version
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

# Define dirs for regular files
%files
/opt/brooklyn/
/var/log/brooklyn/

# Define dirs for config files
%config
/etc/brooklyn/
/etc/systemd/system/brooklyn.service

%changelog
* Tue Feb  2 2016 Aleksandr Vasilev <aleksandr.vasilev@cloudsoftcorp.com> %brooklyn_version-%package_version
- Initial version of the package
