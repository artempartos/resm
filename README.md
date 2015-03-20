# Resm
simple resource manager

## Installation guide
- [install vagrant](https://docs.vagrantup.com/v2/installation/index.html)
- install vagrant-vbguest plugin
```
vagrant plugin install vagrant-vbguest
```
-  [install ansible](http://docs.ansible.com/intro_installation.html)
- install ansible-galaxy plugins (ANXS.erlang, rvm_io.rvm1-ruby). In project directory:
```
ansible-galaxy install -r provision/requirements.yml  --force
```

- up virtual host: in box ubuntu trusty 14.04x64, will have address 192.168.10.10. In project directory:
```
vagrant up
```
(need root password for nfs sync).
This command install erlang, ruby, fpm, resm dependencies

- Check that tests is ok
```
make test
```
- Run RESM application (default port: 8080, default resources: [r1,r2,r3], configurable in apps/resm/src/resm.app.src )
```
make run
```

- Now you can use resource manager in repl or through web interface. Read more in **User guide**

- You also can make deb package and run it as an init.d service. Read more in **Resm as a service**

## User guide

### Repl
```
resm:allocate(partos).
resm:list().
resm:list(partos).
resm:reset().
resm:deallocate(r1).
```

### WEB
```
curl http://resm/allocate/partos
curl http://resm/list
curl http://resm/list/partos
curl http://resm/reset
curl http://resm/deallocate/r1
```
where resm - your server:port with this application,
192.168.10.10:8080 in our case

## Resm as a service

If you want to have resm as a service you need to do next steps:

* Create deb package and install it
```
make deb
sudo dpkg -i resm_[verison].deb
```
* Start service
```
sudo service resm start
```

You will get in log dir (/var/log/resm) something like this
```
Erlang/OTP 17 [erts-6.3] [source-f9282c6] [64-bit] [smp:2:2] [async-threads:10] [hipe] [kernel-poll:false]
Eshell V6.3  (abort with ^G)
(resm@127.0.0.1)
1>
```

That's all!
