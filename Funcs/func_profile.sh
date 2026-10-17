#!/usr/bin/env bash
#          ╭──────────────────────────────────────────────────────────╮
#          │                 Profile 核心函数	                      │
#          ╰──────────────────────────────────────────────────────────╯

#####################################################################

# 脚本所在目录绝对路径
curdir_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# 引入核心函数脚本
source $curdir_path/func_core.sh

#####################################################################

# 安装扩展
# 参数：扩展列表文件(路径)数组
function install_extensions_core() {

	# uid数组
	local arr_t1=()

	# 读取扩展列表文件
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

# 复制配置文件到指定的Profile目录
# 参数1：Profile location
# 参数2：预配置文件路径
# 某Profile配置文件路径：~/.config/Code/User/profiles/Profile id/settings.json
function cp_settings_profile() {
	# Profile location
	local profile_location=$1
	# 预配置文件
	local settings_file=$2

	# 复制配置文件到指定的Profile目录
	cp -rf $settings_file "$profile_location/settings.json"
}

# 复制默认配置文件settings到指定默认目录
# 默认配置文件是放在 ~/.config/Code/User/ 目录下
# 参数1：预制 settings.json 路径
# 参数2：预制 keybindings.json 路径 此参数可选
function cp_settings() {

	# settings文件
	local settings_path=$1
	# keybindings文件
	local keybindings_path=$2

	# 判断settings文件路径参数是否缺失
	if [[ $# -lt 1 ]]; then
		# arg_list+=($default_exlist_path)
		echo -e "\e[93m请提供预制的 \e[96msettings.json \e[93m及 \e[96mkeybindings.json \e[93m路径\n \e[0m"
		return
	fi

	# 将默认Profile的Settings复制到指定目录:~/.config/Code/User/
	echo -e "\e[94m复制 settings ...\n \e[0m"

	cp -v "$settings_path" "$HOME/.config/Code/User/settings.json"

	# 判断是否给了keybindings文件路径参数
	if [[ $# -eq 2 ]]; then
		echo -e "\e[94m复制 keybinddings ...\n \e[0m"
		# 将默认快捷键配置复制到指定目录:~/.config/Code/User/
		cp -v "$keybindings_path" "$HOME/.config/Code/User/keybindings.json"
	fi

	# if [ $? -eq 0 ]; then
	# 	echo -e "\n \e[96m复制配置文件成功！\n \e[0m"
	# else
	# 	echo -e "\n \e[93m复制配置文件失败！\n \e[0m"
	# fi

	# sleep 0.5s
	# 启动VSCode
	# code

}

# 初始化指定Profile
# 参数1：Profile 名称
# 参数2: 可传入任意插件列表文件路径
# 此函数不会自动安装默认插件
# 故至少传入一个插件列表文件路径
function init_profile_custom() {

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

# 根据插件列表为默认（Profile）安装插件
# 参数：扩展列表文件路径，可以是多个，至少有一个
function init_profile_default() {

	# 参数列表数组
	local arg_list=($@)

	# 路径文件是否已经存在参数数组
	# local path_exists="true"

	# 如果没有参数
	if [[ $# -eq 0 ]]; then
		# arg_list+=($default_exlist_path)
		echo -e "\e[93m没有指定扩展列表文件！\n \e[0m"
		return
		# else
		# for element in "${arg_list[@]}"; do
		# 	# 绝对路径是否相同
		# 	if [[ $(readlink -f $element) == $(readlink -f $default_exlist_path) ]]; then
		# 		path_exists="true"
		# 		break
		# 	fi
		#
		# 	path_exists="false"
		# done

		# echo $path_exists

		# 如果参数数组不存在默认插件列表
		# 将默认插件列表路径加入到数组中
		# if [ $path_exists == "false" ]; then
		# 	# echo "没给默认插件列表文件路径"
		# 	arg_list+=($default_exlist_path)
		# fi
	fi

	# echo "${arg_list[@]}"

	# 批量安装扩展
	install_batch_extension "${arg_list[@]}"
	# 复制配置文件
	local default_settings_path=""
	cp_settings_profile "default_settings.json"

}

################################测试#################################

# --------------------------------------------------------------- #
# install_default_extensions $1
# if [ "$1" == "-a" ]; then
# 	init_default_any "$@"
# else
# 	init_default "$@"
# fi

# --------------------------------------------------------------- #

# 为默认Profile复制settings
# cp_settings "$@"




