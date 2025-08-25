#!/bin/bash

# --- 配置 ---
# GitHub 用户名
GIT_USER="automazeio"
# GitHub 仓库名
GIT_REPO="ccpm"
# 临时目录
TMP_DIR="./tmp"
# 下载的 ZIP 文件名
ZIP_FILE="latest.zip"

# --- 脚本开始 ---

# 设置颜色用于输出
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}脚本开始：准备从 ${GIT_USER}/${GIT_REPO} 更新项目...${NC}"

# 1. 构造最新的 master 分支 ZIP 下载链接
# DOWNLOAD_URL="https://github.com/${GIT_USER}/${GIT_REPO}/archive/refs/heads/master.zip"
# 注意：如果主分支不是 master，而是 main，请使用下面的链接
DOWNLOAD_URL="https://github.com/${GIT_USER}/${GIT_REPO}/archive/refs/heads/main.zip"


# 2. 创建临时目录，如果目录已存在，则先清空
echo "正在准备临时目录: ${TMP_DIR}"
if [ -d "$TMP_DIR" ]; then
    echo "  -> 临时目录已存在，正在清空..."
    rm -rf "${TMP_DIR}"/*
else
    echo "  -> 正在创建临时目录..."
    mkdir -p "$TMP_DIR"
fi

# 3. 下载 ZIP 文件
echo "正在从 ${DOWNLOAD_URL} 下载最新的项目文件..."
# 使用 curl 下载。-L 选项用于处理重定向
if curl -L "$DOWNLOAD_URL" -o "${TMP_DIR}/${ZIP_FILE}"; then
    echo -e "${GREEN}  -> 下载成功！${NC}"
else
    echo -e "${RED}  -> 下载失败！请检查网络或 URL 是否正确。${NC}"
    exit 1
fi

# 4. 解压 ZIP 文件到临时目录
echo "正在解压文件到 ${TMP_DIR}..."
unzip -q "${TMP_DIR}/${ZIP_FILE}" -d "$TMP_DIR"
# a. -q (quiet) 安静模式，不输出解压过程
# b. -d 指定解压到的目录

# 检查解压是否成功
if [ $? -ne 0 ]; then
    echo -e "${RED}  -> 解压失败！可能下载的 ZIP 文件已损坏。${NC}"
    exit 1
fi

# 5. 移动文件
# 解压后，文件通常会存放在一个名为 "仓库名-分支名" 的文件夹里，例如 ccpm-master
# 我们需要找到这个文件夹的名字
# 使用 find 命令查找解压后的目录
UNZIPPED_DIR=$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d)

if [ -z "$UNZIPPED_DIR" ]; then
    echo -e "${RED}  -> 找不到解压后的文件夹！${NC}"
    exit 1
fi

echo "正在将文件从 ${UNZIPPED_DIR} 移动到当前目录..."
# 将解压目录下的所有文件（包括隐藏文件）移动到当前目录 (.)
# a. shopt -s dotglob 会让 * 匹配隐藏文件
# b. mv .../* 会移动所有文件
shopt -s dotglob
mv "${UNZIPPED_DIR}"/* .

echo -e "${GREEN}  -> 文件移动完成！${NC}"

# 6. 清理
echo "正在清理临时文件..."
rm -rf "$TMP_DIR"
echo -e "${GREEN}  -> 清理完毕！${NC}"

echo -e "${GREEN}项目更新成功！${NC}"

exit 0
