1. code install 是什么

代码工场，用于各种代码生成，应用程序安装等。

2. 安装 cf

 - 解压 cf.zip 到任意目录（如 d:/cf），可以看到目录中有 bin, data, modules, package 等文件夹（如 d:/cf/bin, d:/cf/data 等）
 - 设置环境变量：CFHOME=d:/cf （根据安装目录写，注意应该使用 / 而不是使用 \）
 - 设置环境变量：PATH，在 PATH 最前面加上 d:\cf\bin;
 - 打开命令行，运行 cf version，如果能够看到版本号，则说明 cf 安装成功
 
3. 使用 cf 安装软件

 - 安装 emacs
   cf install emacs
 - 安装 jdk64
   cf install jdk64
   
