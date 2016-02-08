# Building the RPM on Centos 7

* Download Apache Brooklyn tar.gz file into ```brooklyn-packaging/tarball/``` directory
* Rename it to ```apache-brooklyn-<version>.tar.gz
* Run ```brooklyn-packaging/rpm/make_rpmbuild_dir.sh```
* Install the RPM: ```rpm -Uvh /tmp/brooklyn-buildroot/rpmbuild/RPMS/x86_64```


# Testing Apache Brooklyn systemd service on Centos 7

* Unpack Apache Brooklyn tarball into /opt/brooklyn directory
* Install java: ```sudo yum install java```
* ```sudo groupadd -r brooklyn```
* ```sudo useradd -g brooklyn -r -s /bin/false brooklyn```
* ```sudo chown -R brooklyn:brooklyn /opt/brooklyn```
* Download ```brooklyn.service``` into ```/etc/systemd/system/```
* Restart the systemd daemon service: ```systemctl daemon-reload```
* Run the Brooklyn daemon: ```systemctl start brooklyn```
* Check the process with ```ps aux | grep java```, make sure TTY value is ```?```
* Kill the process, check if it was restarted properly by systemd
* Run ```systemctl brooklyn status```, the process status should be returned
* Run ```systemctl brooklyn restart```, the process should be restarted
* Run ```systemctl brooklyn stop```, the process should be stopped
