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

```bash
git clone https://github.com/myoshimi/openpose-docker
cd openpose-docker
sudo docker build -t openpose .
```

# 使い方

## Openposeで動画処理コマンド

openpose.binのオプションは以下の通り [OpenPose - コマンド一覧(Qiita)](https://qiita.com/wada-n/items/e9e6653effc1e3d0c566)が詳しいので，参照してください．

```bash
docker run --rm --runtime=nvidia \
    -v ${PWD}:/tmp/ openpose:latest \
    --face --hand --part_candidates \
    --display 0 \
    --model_folder /usr/local/openpose/models \
    --video       /tmp/input.avi \
    --write_json  /tmp/outputJSON \
    --write_video /tmp/output.avi
```

* `--write_json` : 時刻ごとの姿勢情報(JSON形式)が出力されるディレクトリ
* `--display 0` : 姿勢推定結果を表示しない( AWSのVMなので途中結果の表示は不要 )
* `--model_folder` : 使用する学習モデルも格納位置の指定
* `--video` : 解析対象となる動画ファイル
* `--write_video` : 解析結果を含んだ動画のファイル

## 静止画処理コマンド

動画と同様に，静止画も解析対象にできます．下記のように，動画ファイルを
指定する代わりに，画像ファイルを格納したディレクトリを指定するだけです．
ディレクトリ内の全ての画像が解析対象になります．

```bash
docker run --rm --runtime=nvidia \
    -v ${PWD}:/tmp/ openpose:latest \
    --face --hand --part_candidates \
    --display 0 \
    --model_folder /usr/local/openpose/models \
    --image_dir    ./image \
    --write_json   ./outputJSON \
    --write_images ./output_image \
```

