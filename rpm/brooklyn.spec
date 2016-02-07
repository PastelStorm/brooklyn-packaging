Name:           apache-brooklyn
Version:        0.8.0
Release:        1
Summary:        The Apache Brooklyn program from brooklyn.apache.org

Group:          Applications/Internet
License:        ASL 2.0
URL:            https://brooklyn.apache.org/
Source0:        apache-brooklyn-0.8.0.tar.gz
Requires:       java

%description
Apache Brooklyn is a framework for modeling, monitoring, and managing applications through autonomic blueprints.

%prep
%setup -q

%pre
/bin/getent group brooklyn || /sbin/groupadd -r brooklyn
/bin/getent passwd brooklyn || /sbin/useradd -r -g brooklyn -d /opt/brooklyn -s /sbin/nologin brooklyn

%post
/bin/systemctl daemon-reload
/bin/systemctl start brooklyn
/bin/chown -R brooklyn:brooklyn /opt/brooklyn/
/bin/chown -R brooklyn:brooklyn /var/run/brooklyn/
/bin/chown -R brooklyn:brooklyn /etc/brooklyn/

%preun
/bin/systemctl stop brooklyn

%postun
/sbin/userdel brooklyn

%files
/etc/brooklyn/brooklyn.conf
/etc/systemd/system/brooklyn.service
/opt/brooklyn/
/var/run/brooklyn/

%changelog
* Tue Feb  2 2016 Aleksandr Vasilev <aleksandr.vasilev@cloudsoftcorp.com> 0.8.0-1
- Initial version of the package
