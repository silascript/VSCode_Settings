#!/usr/bin/env bash

#          ╭──────────────────────────────────────────────────────────╮
#          │                         基础函数                         │
#          ╰──────────────────────────────────────────────────────────╯

# 删除目录
# 给出一个参数，即要删除目录的路径
rm_dir() {

	local dir_path=$1

	if [ ! -d $dir_path ]; then
		echo -e "\e[93m $dir_path \e[96m目录不存在！\e[96m...\n \e[0m"
	else
		rm -rf $dir_path
		if [ $? -eq 0 ]; then
			echo -e "\e[92m $dir_path \e[96m目录删除成功！\e[96m...\n \e[0m"
		else
			echo -e "\e[93m $dir_path \e[96m目录删除失败！\e[96m...\n \e[0m"
		fi
	fi

}

#############################################################################
#          ╭──────────────────────────────────────────────────────────╮
#          │                          测试区                          │
#          ╰──────────────────────────────────────────────────────────╯

# rm_dir $1
