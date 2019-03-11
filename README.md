# openpose-docker

* openposeをコンテナで実行するDockerfileです
    * ```docker run``` コマンドに，入力ファイルとオプションを指定して
      実行することで，Openposeの処理を実現します

# 準備

Dockerホストは以下の条件を満たしている必要があります．

* Linux OSがインストールされていること
    * AWS g3s.xlarge，ubuntu18.04で動作確認しています
* nvidia社のGPUが搭載されていること
* docker-ce，nvidia-docker2がインストールされていること

# Dockerイメージのビルド

```

docker build -t openpose .
```

# 使い方

```
docker run --rm --runtime=nvidia \
    -v ${PWD}:/tmp/ openpose:latest \
    --face --hand --part_candidates \
    --display 0 \
    --model_folder /usr/local/openpose/models \
    --video       /tmp/billy_output.avi \
    --write_json  /tmp/outputJSON2 \
    --write_video /tmp/tmp_billy_output.avi
```
