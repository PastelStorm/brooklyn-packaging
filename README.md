# Building Brooklyn .rpm and .deb packages for Centos 7 and RHEL 7 with systemd support.

* Install ```ruby-dev/ruby-devel```, ```gcc``` and ```make``` packages on your system
* Install ```json-pure``` gem: ```gem install json-pure```
* Install ```fpm``` gem: ```gem install fpm```
* Install ```gnu-tar``` if building on Mac OS X: ```brew install gnu-tar```
* Clone the repo: ```git clone https://github.com/alrick87/brooklyn-packaging.git```
* Change directory to brooklyn-packaging directory: ```cd brooklyn-packaging```
* Download Apache Brooklyn tar.gz file into ```tarball/``` directory
* Run ```./build_package.sh <package_type> <package_release_version>```, for example: ``` ./build_package.sh rpm 1```
* The package will appear in ```packages/``` directory
