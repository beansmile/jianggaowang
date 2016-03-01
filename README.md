讲稿网
====

讲稿网旨在为讲稿的收集以及分享提供一个简单实用的平台，核心功能包括但不限于PDF文档的格式转换、图片水印，都依赖七牛云存储API实现。讲稿网现已开源，欢迎各位朋友以Pull Request的方式贡献代码，帮助讲稿网变得更加好用。

#### 如何贡献代码
1. Fork代码并且git clone到您电脑上的任意目录；
2. 进入到项目目录，并且执行`bundle install`；
3. 进行相关配置，这部分会在[“如何搭建开发环境”](#%E5%A6%82%E4%BD%95%E6%90%AD%E5%BB%BA%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83)部分详细讲解；
4. 进行开发编码并且提交到一个远程分支；
5. 从您fork后的代码库的远程分支发起到`beansmile/jianggaowang`master分支的Pull Request。

#### 如何搭建开发环境
1. 拷贝一份`database.yml`文件：
```sh
cp config/database.yml.example config/database.yml
```
并且按照您自己的数据库配置，修改`config/database.yml`中的相关配置，比如数据库用户名以及密码。
2. 打开ngrok映射本地3000端口（或者是其他用于稍后的Rails server的端口）到公网
```sh
ngrok 3000    # 如果您已经在ngrok网站上注册了新用户，您就可以加上subdomain参数尝试绑定指定二级域名，比如`ngrok -subdomain=jgw 3000`
```
3. [拷贝一份`secrets.yml`文件并且执行配置](#%E5%A6%82%E4%BD%95%E9%85%8D%E7%BD%AEsecretsyml%E6%96%87%E4%BB%B6)
4. 启动Rails服务器
  ```sh
  rails s
  ```
5. 启动sidekiq
  ```sh
  sidekiq -d
  ```
6. 本地开发环境搭建完成

#### 如何配置`secrets.yml`文件
```sh
cp config/secrets.yml.example config/secrets.yml
```
*注意*如果使用自己的七牛云空间的话，需要自定义域名，且需要自定义的域名与空间名一样，比如: yourdomain.qiniu.com
以下以`development`组中的配置为例讲解各个配置项的作用：
```yaml
development:
  secret_key_base: d3f539adshh8s7sb0751b65c5a4531e5ab781b6ed745124c9a266fb0f7ade05c81b9f9ef9e4addda72e23874a3bc7e1b13bb7365abb2b9beeb548403334e
  host: 'http://jgw.ngrok.com'
  qiniu:
    access_key: WoloGjHR0tX8Y87hv8T2uIAYO4KrfI7EPXw7kRLI
    secret_key: hy7PJgnhiysuis789vpHAB_oGiP7nkQhUkMr0Ges-E
    bucket: jianggao-development
    mps_queue: jianggaodevelopment
  mail:
    user_name: 'jianggaowang@example.com'
    password: 'examplepassword'
```
* `secret_key_base`: 这个参数是Rails项目的必要项，用于指定项目中的secret token，更多用处请阅读[Ruby on Rails Security Guide](http://guides.rubyonrails.org/security.html#session-storage)。
* `host`: 用于配置主机域名信息，以便外部服务器能够在公网上访问到本地开发服务器，至于如何将本地机器映射到公网上，建议使用**[ngrok](https://ngrok.com/)**命令行程序实现，并且此处只要填写ngrok分配的二级域名即可。
* `qiniu`: 这个配置组主要配置与七牛API相关的参数，各个具体参数的配置项说明如下：
    * `access_key`: 七牛开发者的access_key，可以前往[七牛云存储](http://www.qiniu.com/)注册成为开发者后即可获取。
    * `secret_key`: 同上`access_key`，成为七牛开发者后即可获得。
    * `bucket`: 指定项目文件上传到七牛后的目标bucket（七牛称之为“空间”），请记得登陆自己的七牛云存储账号并且建好新的空间。
    * `mps_queue`: 七牛为开发者提供了["多媒体处理服务(Multimedia Processing Service)"](https://portal.qiniu.com/mps/pipeline/intro)，实质上就是多媒体文件处理队列，您可以自己创建一个新的队列，并且将队列名称配置到此参数上。**注意：**因为此项目中用到了处理队列的预设规格,所以请在上一步建立好的空间设置里配置[“数据处理”](https://portal.qiniu.com/bucket/jianggao-development/processor/image)，并且一个叫做“preview”的图片样式，请详细参数为：
    ```
    处理方式： 指定宽高缩放。
    图片尺寸： 宽度200px
    图片质量： 100
    图片格式： 默认
    样式： imageView2/2/w/200/q/100
    ```
* `mail`: 用于配置邮件发送的相关参数，邮件目前使用163，如果需要使用其他邮件厂商的邮箱，请记得同时修改`config/initializers/smtp.rb`中的邮箱配置，但是请记得不要提交这部分的更改。
    `username`: 邮箱用户名
    `password`: 用于登陆邮箱的密码

#### 配置redis数据库

```sh
# 先安装redis
brew install redis
```

```sh
# 再运行redis
redis-server
```

#### 启动sidekiq
```sh
bundle exec sidekiq -C config/sidekiq.yml
```

#### PDF 文件转换系统环境依赖
1. GhostScript
2. ImageMagick