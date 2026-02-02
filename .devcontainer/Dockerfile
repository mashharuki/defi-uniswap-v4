FROM mcr.microsoft.com/devcontainers/rust:1-1-bookworm

# Foundryのインストール（rootユーザーとして実行）
RUN curl -L https://foundry.paradigm.xyz | bash && \
    /root/.foundry/bin/foundryup

# PATHを設定
ENV source /home/vscode/.bashrc

USER vscode