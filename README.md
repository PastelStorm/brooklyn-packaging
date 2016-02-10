# Building Brooklyn .rpm and .deb packages for CentOS 7 and RHEL 7 with systemd support.

* Install ```rpm-build``` package (available on CentOS, Ubuntu, Mac OS X)
* Clone the repo: ```git clone https://github.com/alrick87/brooklyn-packaging.git```
* Change directory to brooklyn-packaging directory: ```cd brooklyn-packaging```
* Download Apache Brooklyn tar.gz file into ```tarball/``` directory
* Run ```./build_package.sh <package_release_version>```, for example: ``` ./build_package.sh 1```
* The package will appear in ```packages/``` directory
