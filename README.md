# Resm
simple resource manager

## Installation guide
-  [Install erlang/OTP](http://www.erlang.org/doc/installation_guide/INSTALL.html)
- Fetch and compile dependencies
```
make
```
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

- Development machine has ubuntu trusty with Erlang/OTP 17.4 and ruby 2.1.5

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
where resm - your server:port with this application

## Resm as a service

If you want to have resm as a service you need to do next steps:

* [Install ruby environment](https://www.ruby-lang.org/en/documentation/installation/) and [gem fpm](https://github.com/jordansissel/fpm)

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
