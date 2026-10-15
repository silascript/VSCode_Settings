#!/usr/bin/env bash
#          ╭──────────────────────────────────────────────────────────╮
#          │                      重置初始化                          │
#          ╰──────────────────────────────────────────────────────────╯

# 当前目录绝对路径
declare -r CUR_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# 引入重置函数脚本
source $CUR_PATH/Funcs/func_reset.sh

init_vscode() {

	echo -e "\n \e[94m 重置初始化 VSCode ... \n \e[0m"
	# 删除 VSCode相应 目录
	rm_vscdir

	echo -e "\e[96m 重启VSCode ...\n \e[0m"
	sleep 0.5s
	# 重启 VSCode
	# VSCode 会自动生成 ~/.vscode/ 及 ~/.config/Code/ 目录
	code
}

########################################################################
init_vscode
