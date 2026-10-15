#!/usr/bin/env bash

#          ╭──────────────────────────────────────────────────────────╮
#          │                        重置函数                          │
#          ╰──────────────────────────────────────────────────────────╯

# 当前目录绝对路径
# declare -r CUR_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# 导入基础函数
source func_basic.sh
# source  ./func_basic.sh

##############################################################################

# 删除相关目录
# ~/.vscode/ 及 ~/.config/Code/
function rm_vscdir() {

	# echo ${HOME}

	# vscode的根目录 即 ~/.vscode/ 目录
	local vscode_rootdir="${HOME}/.vscode"
	# vscode 的配置目录 即 ~/.config/Code/ 目录
	local vscode_configdir="${HOME}/.config/Code"

	# 删除 ~/.vscode/ 目录
	rm_dir $vscode_rootdir

	sleep 0.05

	# 删除 ~/.config/Code/ 目录
	rm_dir $vscode_configdir
}

##############################################################################

#          ╭──────────────────────────────────────────────────────────╮
#          │                         测试区                           │
#          ╰──────────────────────────────────────────────────────────╯
# rm_vscdir
