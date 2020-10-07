# docker-n8nio

## 説明

社内でゆるく使えるワークフローを立てたかった  
以下、参考  
[DockerHub - n8nio/n8n](https://hub.docker.com/r/n8nio/n8n/dockerfile)

## 環境

```bash
$ cat /etc/redhat-release
$ CentOS Linux release 7.8.2003 (Core)
$ arch
$ x86_64
```

## n8n.io 環境の構築

### DockerFile の Build

```bash
$ docker build -t <イメージ名> <DockerFileのパス>
```

#### 実行例

```bash
$ [root@localhost n8n] docker build -t test-n8n .
Sending build context to Docker daemon   2.56kB
Step 1/10 : FROM node:12.13.0-alpine
 ---> 69c8cc9212ec
Step 2/10 : LABEL maintainer="august8"
 ---> Using cache
 ---> 4303bdd29403
Step 3/10 : RUN echo "now building ...."
 ---> Using cache
 ---> 16309f9af50f
Step 4/10 : ENV N8N_VERSION=latest
 ---> Using cache
 ---> f2bb8154e9df
Step 5/10 : RUN if [ -z "$N8N_VERSION" ] ; then echo "The N8N_VERSION argument is missing!" ; exit 1; fi
 ---> Using cache
 ---> fc67f7c52d5e
Step 6/10 : USER root
 ---> Using cache
 ---> cebb79530a94
Step 7/10 : RUN apk --update add --virtual build-dependencies python build-base ca-certificates &&   npm_config_user=root npm install -g n8n@${N8N_VERSION} &&   apk del build-dependencies
 ---> Using cache
 ---> b3511cbe0868
Step 8/10 : WORKDIR /data
 ---> Using cache
 ---> 957f90143438
Step 9/10 : EXPOSE 5678:5678
 ---> Using cache
 ---> 724767f04a8b
Step 10/10 : CMD ["n8n"]
 ---> Using cache
 ---> 84ea3a67437e
Successfully built 84ea3a67437e
Successfully tagged test-n8n:latest
```

#### 実行結果確認

```bash
$ [root@localhost n8n] docker images
REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
test-n8n               latest              84ea3a67437e        4 hours ago         289MB
```

### docker image 　の起動

```bash
$ docker start -p <docker image コンテナのポート:ホストマシンのポート> -d <docker image>
```

> -d : コンテナをバックグラウンドで実行  
> -p : ポートの設定

### ファイアーウォールの設定変更

#### これを行わないと同一ホストの別のコンテナからワークフローの実行が行えなかった。

```bash
$ sudo firewall-cmd --add-port=5678/tcp --zone=public --permanent
$ sudo firewall-cmd --reload
```

### docker の停止, 削除

```bash
$ docker stop <コンテナID>  // 停止
$ docker rm <コンテナID>   // 削除
```

---

### 以下は必要な場合のみ実行

#### OS 起動時に、Docker の起動を設定

```bash
$ systemctl enable --now docker
```

#### Docker コマンドでの sudo を許可

```bash
$ sudo usermod -aG docker $USER
```
