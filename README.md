# Building the RPM on Centos 7

* Download Apache Brooklyn tar.gz file into ```brooklyn-packaging/tarball/``` directory
* Rename it to ```apache-brooklyn-<version>.tar.gz```
* Run ```brooklyn-packaging/rpm/make_rpmbuild_dir.sh```
* Install the RPM: ```rpm -Uvh /tmp/brooklyn-buildroot/rpmbuild/RPMS/x86_64```
