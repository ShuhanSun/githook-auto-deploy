
## git-auto-deploy

#### Abstract
Auto deploy when pushed code to git;  实现代码推送git后，自动发布部署;
using git-hook and spring-boot; 使用git-hook 与spring-boot实现;
support multi-user; 支持多用户;
support multi-project; 支持多项目;

#### Use the steps Description ：
1. write deploy shell 自己写好发布脚本(拉取最新代码、打包、重启等)
2. start 启动本服务(ip:port) Eg: java -jar githook-deploy-1.0-SNAPSHOT.jar --server.port=8888 > auto-deploy.log 2>&1 &
3. set git hook git服务器上或git web hook 配置hook调用本服务接口 POST ip:port/{project}, (project为项目部署目录名)
4. set deploy shell path 配置发布脚本的路径 deploy.shell.path.template, 或调用此接口每个项目单独配置动态修改 POST ip:port/{project}/deploy/shell?path=xxx
5. set deploy get branch 设置需要自动发布的分支 auto.deploy.branch，或调用接口动态修改 POST ip:port/git/branch?branch=xxx (default默认 deploy-test)
6. (optional) auto deploy on-off 每个项目的自动发布开关控制 POST /{project}/auto/deploy?enable=false (默认开启)

#### TODO
extension points : pre/post deploy 重启前、后的扩展点，Eg: send mail to submitter after deploy 重启完成后发送邮件通知提交者。
