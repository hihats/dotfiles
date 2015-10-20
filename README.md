# Creation of an Environment 環境構築

## Mac OSX
[XCode Install](https://developer.apple.com/jp/xcode/)
```bash
sudo xcodebuild -license
```
```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" ```

```bash
brew tap homebrew/brewdler
```

Applications can be in [Brewfile](https://github.com/hihats/dotfiles/blob/master/Brewfile)


```bash
$ ln -sf ~/Dropbox/Public/.ssh/config ~/.ssh/config
```

### Ruby Env
```bash
rbenv global 2.2.0
rbenv rehash

rbenv exec gem install bundler
```
http://morizyun.github.io/blog/marvericks-rails-setup-ruby-rvm-msyql/
http://www.1x1.jp/blog/2014/04/how-to-setup-application-on-osx.html

### atom
[sync setting](http://morizyun.github.io/blog/marvericks-rails-setup-ruby-rvm-msyql/
http://www.1x1.jp/blog/2014/04/how-to-setup-application-on-osx.html
)

## Sublime Text
### Package Control
### .settingファイル


##aws setup
```bash
$ vim /etc/hosts
$ vim /etc/sysconfig/network
```
### create user
```bash
$ sudo useradd hihats
$ sudo passwd hihats
$ sudo visudo
$ sudo gpasswd -a hihats wheel
```
### install middleware

```bash
$ sudo vim /etc/sysconfig/i18n
sudo yum update
sudo yum install ruby-devel gcc sqlite-devel gcc-c++
sudo yum install openssl-devel readline-devel zlib-devel curl-devel libyaml-devel
sudo yum list
sudo yum list | grep mysql
sudo yum install patch
yum repolist
sudo yum install mysql-server mysql-devel
sudo yum install httpd httpd-devel
sudo yum install graphviz
sudo yum install memcached
sudo yum install make bzip2 autoconf automake libtool bison git
sudo yum install libffi
sudo yum install libffi-devel
```


### LinuxにRails環境構築
[Linux環境へrbenv install](http://weblabo.oscasierra.net/install-rbenv-rubybuild-to-redhat/)
[rbenvをシステムワイドにインストールする](http://office.tsukuba-bunko.org/ppoi/entry/systemwide-rbenv)
[CentOSでsystem wideなrbenv+ruby-build環境を構築する](http://nomnel.net/blog/centos-system-wide-rbenv-and-ruby-build/)

root
```bash
cd /usr/local/
git clone https://github.com/sstephenson/rbenv.git
echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile
echo 'export PATH="${RBENV_ROOT}/bin:${PATH}"' >> /etc/profile
echo 'eval "$(rbenv init -)"' >> /etc/profile
cat /etc/profile

mkdir rbenv/plugins
cd rbenv/plugins/
git clone git://github.com/sstephenson/ruby-build.git
. /etc/profile
rbenv install -l
rbenv install 2.0.0-p643
rbenv global 2.0.0-p643
ruby -v
exit
grep 'secure_path' /etc/sudoers
grep -n 'secure_path' /etc/sudoers
vim /etc/sudoers
exit
cd /usr/local/
mkdir rbenv/shims rbenv/versions
groupadd rbenv
chgrp -R rbenv rbenv
chmod -R g+rwxXs rbenv =>  Seccurity Error!!
```

SGID権限はRuby2.0以降でErrorとなる
:warning:[システムワイドな rbenv の SecurityError](http://indeep.xyz/system-wide-rbenv-securityerror/)
```bash
sudo visudo
bash -c 'cat <<\__EOT__ >> ~/.bash_profile
export RBENV_ROOT="/usr/local/rbenv"
export PATH="${RBENV_ROOT}/bin:${PATH}"
eval "$(rbenv init -)"
__EOT__'

sudo gem install passenger
```
root

	passenger-install-apache2-module

### LinuxにPHP環境構築
phpenv使用
```bash
$ cd /usr/local/
$ git clone https://github.com/CHH/phpenv
$ cd phpenv/bin
$ ./phpenv-install.sh
$ echo 'export PHPENV_ROOT="/usr/local/phpenv"' >> /etc/profile

$ yum install bison re2c
$ yum install libxml2 libxml2-devel
$ yum install jpeglib.h
$ yum install libpng-devel libjpeg-devel
$ yum install libmcrypt-devel.x86_64
$ yum install libtidy libtidy-devel
$ yum install autoconf.noarch
$ phpenv install 5.6.14
$ phpenv rehash
$ phpenv global 5.6.14
```
[20+ common PHP compilation errors and fix – Unix](http://crybit.com/20-common-php-compilation-errors-and-fix-unix/)
[phpenv+php-build環境によるphpバージョン管理~Mac（Yosemite）編~](http://qiita.com/omega999/items/c5b1c177331f8d342efd)
[ubuntuにphp-buildでphp5.5を入れるためにシェルスクリプトと格闘した記録](http://hirobanex.net/article/2013/09/1379231000)
`rbenv: version `2.2.3' is not installed (set by RBENV_VERSION environment variable)`とRBENV_VERSIONについて怒られる場合がある。phpenvがRBENV_VERSION変数を見に行ってしまっている。

### Passenger install
EC2のt2.microではメモリが足りなくてコンパイル出来ませんでした。t2.small以上を選択する必要があります。
[Virtual Memory Exhausted: Cannot Allocate Memory While Install Passenger on AWS](http://dynamicy.github.io/blog/2014/11/01/virtual-memory-exhausted/)


### apacehグループにgpasswdで追加できない問題発生
/etc/groupにはある


### MySQL起動
	CREATE USER
	SET PASSWORD for hihats = PASSWORD('******');
	GRANT ALL PRIVILEGES ON *.* TO
	CREATE DATABASE itbee_development DEFAULT CHARACTER SET utf8;
