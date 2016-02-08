# Building the RPM on Centos 7

* Clone the repo: ```git clone https://github.com/alrick87/brooklyn-packaging.git```
* Download Apache Brooklyn tar.gz file into ```brooklyn-packaging/tarball/``` directory
* Rename the tarball to ```apache-brooklyn-<version>.tar.gz```, i.e. ```apache-brooklyn-0.8.0.tar.gz```
* Run ```brooklyn-packaging/rpm/make_rpmbuild_dir.sh```
* Install the RPM: ```rpm -Uvh /tmp/brooklyn-buildroot/rpmbuild/RPMS/x86_64```
