# 说明
## 从https://github.com/open-webui/open-webui git原码
## 把DOCKERFILE  buildopenwebui.sh复制到原码，覆盖原文件
## 执行buildopenwebui.sh（最好先docker pull node:22-alpine3.20 再执行）
## 完成后会自动运行docker，进行镜像，将/root/app.tar.gz复制出来
# app.tar.gz就是编译好的open-webui的前后台代码

# 安装
## debian或ubuntu，复制app.tar.gz到系统，并解压tar -xzvf app.tar.gz -C /
## 需要python3.11环境，如果没有，先安装installpython3.11.sh
## 执行installopenwebui.sh安装open-webui
## 注意：如果sqlite3(<0.35),installopenwebui.sh会以pysqlite3-binary替代。