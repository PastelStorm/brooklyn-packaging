# Building Brooklyn .rpm packages for CentOS 7 and RHEL 7 with systemd support.

* Install ```rpm-build``` package (```rpm``` on Ubuntu)
* Clone the repo: ```git clone https://github.com/alrick87/brooklyn-packaging.git```
* Change directory to brooklyn-packaging directory: ```cd brooklyn-packaging```
* Download Apache Brooklyn tar.gz file into ```tarball/``` directory
* Run ```./build_package.sh <package_release_version>```, for example: ``` ./build_package.sh 1```
* The package will appear in ```package/``` directory

# Signing the .rpm package (only on Centos/RHEL systems)

* Copy Apache Brooklyn GPG key into ```key/``` directory
* Run ```./sign_package.sh <path_to_password_file>```, for example: ```./sign_package.sh ~/brooklyn_sign_password.txt```
* Test if the package was signed correctly: ```rpm -qpi <path_to_signed_rpm> | awk '/Signature/'```
