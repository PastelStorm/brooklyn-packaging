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
Source0:        apache-brooklyn-%brooklyn_version.tar.gz
Requires:       java

%description
Apache Brooklyn is a framework for modeling, monitoring, and managing applications through autonomic blueprints.

%clean
/usr/bin/rm -rf /tmp/brooklyn-buildroot

# Set up a group and a user to run Brooklyn
%pre
/bin/getent group brooklyn || /sbin/groupadd -r brooklyn
/bin/getent passwd brooklyn || /sbin/useradd -r -g brooklyn -d /opt/brooklyn -s /sbin/nologin brooklyn

# Set the files ownership and start systemd daemon
%post
/bin/chown -R brooklyn:brooklyn /opt/brooklyn/
/bin/chown -R brooklyn:brooklyn /var/run/brooklyn/
/bin/chown -R brooklyn:brooklyn /etc/brooklyn/
/bin/systemctl daemon-reload
/bin/systemctl start brooklyn

# Stop Brooklyn service before uninstalling the package
%preun
/bin/systemctl stop brooklyn

# Delete the user
%postun
/sbin/userdel brooklyn

# The files to run Brooklyn
%files
/etc/brooklyn/brooklyn.conf
/etc/systemd/system/brooklyn.service
/opt/brooklyn/
/var/run/brooklyn/

%changelog
* Tue Feb  2 2016 Aleksandr Vasilev <aleksandr.vasilev@cloudsoftcorp.com> %brooklyn_version-%package_version
- Initial version of the package
