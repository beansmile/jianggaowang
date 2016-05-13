[讲稿网](http://jianggaowang.com/)
=================================

[讲稿网](http://jianggaowang.com/)旨在为讲稿的收集以及分享提供一个简单实用的平台，核心功能包括但不限于 PDF 文档的格式转换、图片水印。讲稿网现已开源，欢迎各位朋友以 Pull Request 的方式贡献代码，帮助讲稿网变得更加好用。

## 如何贡献代码

1. Fork 代码并且 git clone 到您电脑上的任意目录；
2. 进入到项目目录，并且执行 `bundle install`；
3. 进行相关配置，这部分会在如何搭建开发环境部分详细讲解；
4. 进行开发编码并且提交到一个远程分支；
5. 从您 fork 后的代码库的远程分支发起到 `beansmile/jianggaowang` develop 分支的 Pull Request。

## 如何搭建开发环境

### 安装系统环境依赖

```sh
brew install redis # Sidekiq 依赖
brew install ghostscript imagemagick # PDF 转换依赖
```

### 配置 Rails

1. 拷贝一份 `database.yml` 文件：
  ```sh
  cp config/database.yml.example config/database.yml
  ```
并且按照您自己的数据库配置，修改 `config/database.yml` 中的相关配置，比如数据库用户名以及密码。

2. 拷贝一份 `secrets.yml` 文件
  ```sh
  cp config/secrets.yml.example config/secrets.yml
  ```

3. Bundle & Create db
  ```sh
  bundle install
  bundle exec rake db:reset
  ```

4. 启动 Sidekiq
  ```sh
  bundle exec sidekiq -C config/sidekiq.yml
  ```

5. 本地开发环境搭建完成，启动Rails服务器
  ```sh
  bundle exec rails s
  ```

### 配置 EsLint 和 StyleLint

1. 安装

```sh
npm install
```

2. 配置编辑器

  1. For EsLint
  
    * 如Sublime，可安装 [SublimeLinter-eslint](https://github.com/roadhump/SublimeLinter-eslint)
    * 如Atom, 可安装插件 `linter-eslint` ，勾选选项 `Use global ESLint installation`
    * 如Vim, 可安装插件[syntastic](https://github.com/scrooloose/syntastic), 在`.vimrc`里加入`let g:syntastic_javascript_checkers = ['eslint']`
    * 如有需要，可修改配置：`.eslintrc.js`

  2. For StyleLint
  
    * 如SublimeText， 可安装 [SublimeLinter-contrib-stylelint](https://github.com/kungfusheep/SublimeLinter-contrib-stylelint)
    * 如Atom， 可安装 [linter-stylelint](https://atom.io/packages/linter-stylelint)
    * 如有需要，可修改配置： `.stylelintrc`

* Refs:

  - [eslint-plugin-react](https://github.com/yannickcr/eslint-plugin-react/tree/master/docs/rules)
  - [eslint-config-airbnb](https://github.com/airbnb/javascript/tree/master/packages/eslint-config-airbnb/rules)
  - [eslint config](http://eslint.org/docs/user-guide/configuring)
  - [stylelint](https://github.com/stylelint/stylelint)
  - [stylelint-config-standard](https://github.com/stylelint/stylelint-config-standard)


### 其他

由于网站还处于内测阶段，所以本地开发新注册的用户是没有登录权限的。快速修改新注册用户登录权限的方法是，启动 rails console，将用户的 `approved_at` 字段设为一个时间值，用户就可以登录了。
