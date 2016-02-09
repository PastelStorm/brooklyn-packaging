# Building the RPM on Centos 7

* Install rpm-build package ```yum install rpm-build```
* Clone the repo: ```git clone https://github.com/alrick87/brooklyn-packaging.git```
* Change directory to brooklyn-packaging directory: ```cd brooklyn-packaging```
* Download Apache Brooklyn tar.gz file into ```tarball/``` directory
* Run ```./build_rpm.sh <package_release_version>```, for example: ``` ./build_rpm.sh 1```
* Install the RPM: ```rpm -Uvh /tmp/brooklyn-buildroot/rpmbuild/RPMS/x86_64/<rpm_name>```
