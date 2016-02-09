# Building the RPM on Centos 7

* Install rpm-build package ```yum install rpm-build```
* Clone the repo: ```git clone https://github.com/alrick87/brooklyn-packaging.git```
* Download Apache Brooklyn tar.gz file into ```brooklyn-packaging/tarball/``` directory
* Run ```brooklyn-packaging/build_rpm.sh```
* Install the RPM: ```rpm -Uvh /tmp/brooklyn-buildroot/rpmbuild/RPMS/x86_64/<rpm_name>```
