#!/usr/bin/env bash
#          ╭──────────────────────────────────────────────────────────╮
#          │                 Pfofile 初始化核心函数                   │
#          ╰──────────────────────────────────────────────────────────╯

#####################################################################
# 引入核心函数脚本
source ./func_core.sh

#####################################################################

# 安装扩展
function install_extensions_core() {

	# uid数组
	local arr_t1=()

	arr_t1=($(read_extension_list "$@"))
	# echo ${arr_t1[@]}

	echo -e "\n\e[94m将要安装插件如下： \n \e[0m"

	# 打印插件数组
	print_exarr "${arr_t1[@]}"

	sleep 0.05

	echo -e "\n\e[94m开始安装插件 ... \n \e[0m"
	# 进行批量安装
	install_batch "${arr_t1[@]}"

	sleep 0.02

	echo -e "\n\e[96m所有插件安装完毕！... \n \e[0m"
}

#####################################################################

# 复制配置文件settings到指定目录
# function cp_settings() {
#
# 	local profile_dir_name=$1
#
# 	# 当前脚本的绝对路径
# 	local current_path=$(cd `dirname $0`;pwd)
#
# 	# 将默认Profile的Settings复制到指定目录:~/.config/Code/User/
# 	echo -e "\e[94m复制 settings ...\n \e[0m"
# 	cp -v "${current_path}/default_settings.json" "$HOME/.config/Code/User/${profile_dir_name}/settings.json"
#
# 	# 将默认快捷键配置复制到指定目录:~/.config/Code/User/
# 	cp -v "${current_path}/default_keybindings.json" "$HOME/.config/Code/User/${profile_dir_name}/keybindings.json"
#
# 	if [ $? -eq 0 ]; then
# 		echo -e "\n \e[96m复制 settings 成功！\n \e[0m"
# 	else
# 		echo -e "\n \e[93m复制 settings 失败！\n \e[0m"
# 	fi
# }

# 复制配置文件到指定的Profile目录
# 参数1：Profile location
# 参数2：预配置文件
# 某Profile配置文件路径：~/.config/Code/User/profiles/Profile id/settings.json
function cp_settings_profile() {
	# Profile location
	local profile_location=$1
	# 预配置文件
	local settings_file=$2
}

# 初始化指定Profile
# 参数1：Profile 名称
# 参数2: 可传入任意插件列表文件路径
# 此函数不会自动安装默认插件
# 故至少传入一个插件列表文件路径
function init_profile_any() {

	# 默认Profile 扩展uid列表路径
	# local default_exlist_path=$1

	local profile_name=$1

	# 移除第一个参数
	shift

	# 接收多个扩展列表文件路径
	local exlist_arr=($@)

	# echo ${exlist_arr[@]}

	# 去除 `-a` 选项参数
	# if [[ $1 == "-a" ]]; then
	# 	unset exlist_arr[0]
	# fi

	if [ "${#exlist_arr[@]}" -eq 0 ]; then
		echo -e "\e[93m没有指定扩展列表文件！\n \e[0m"
	else
		#  根据扩展列表，安装默认扩展
		install_extensions_core "${exlist_arr[@]}"

		# 复制预设 settings 到指定Profile目录
		# 包括 settings.json及 keybindings.json
		cp_settings_profile
	fi

}

# 根据插件列表为默认Profile安装插件
# 无论有没有传入插件列表参数都会安装默认插件
# 故此函数可以无参执行
# 默认插件列表默认路径：./Extension_List/exlist_default.txt
function init_default() {

	# 参数列表数组
	local arg_list=($@)

	# 默认插件列表
	local default_exlist_path="./Extension_List/exlist_default.txt"
	# 默认插件列表的md5值
	# local md5v_default_exlist_file=$(md5sum $default_exlist_path)

	# 路径文件是否已经存在参数数组
	local path_exists="true"

	# 如果没有参数
	if [[ $# -eq 0 ]]; then
		# 加上默认插件列表
		arg_list+=($default_exlist_path)
	else

		for element in "${arg_list[@]}"; do
			# 绝对路径是否相同
			if [[ $(readlink -f $element) == $(readlink -f $default_exlist_path) ]]; then
				path_exists="true"
				break
			fi

			path_exists="false"
		done

		# echo $path_exists

		# 如果参数数组不存在默认插件列表
		# 将默认插件列表路径加入到数组中
		if [ $path_exists == "false" ]; then
			# echo "没给默认插件列表文件路径"
			arg_list+=($default_exlist_path)
		fi
	fi

	# echo "${arg_list[@]}"

	init_default_any "${arg_list[@]}"
}

#####################################################################

# install_default_extensions $1
# if [ "$1" == "-a" ]; then
# 	init_default_any "$@"
# else
# 	init_default "$@"
# fi
