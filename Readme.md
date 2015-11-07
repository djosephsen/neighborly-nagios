#Neighborly Nagios

This [LISA-2015 tutorial
session](https://www.usenix.org/conference/lisa15/training-program/session/neighborly-nagios)
is an introductory course on Nagios that emphasizes Data I/O and cooperation
with other monitoring tools.

If you're taking the course, and you'd like to follow along you should bring a
laptop with [Vagrant](https://www.vagrantup.com/) installed, along with a
"trusty64" image. I'll be using
[this](https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box)
one, which you can grab by typing: 

``` 
vagrant box add trusty64 https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box
``` 
You should do that any time before the day of the class because it's a
relatively large download.  The [vm](/vm) directory contains everything you
need to boot and set up the vagrant box for the tutorial. To get set-up run: 

```
git clone https://github.com/djosephsen/neighborly-nagios.git
cd neighborly-nagios/vm
vagrant up
```

That part you should probably do the night before the tutorial starts just to
make sure you have the latest version of everything. See you there!
