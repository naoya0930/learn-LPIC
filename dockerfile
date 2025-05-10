# Ubuntu ベースのシンプルな Dockerfile
FROM ubuntu:22.04

# 必要に応じてツールをインストール
RUN apt-get update && apt-get install -y \
    bash \
    vim \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを指定（お好みで）
WORKDIR /workspace 