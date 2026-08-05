#!/usr/bin/env bash

#          ╭──────────────────────────────────────────────────────────╮
#          │						核心函数                          │
#          ╰──────────────────────────────────────────────────────────╯

# 检测userDataProfiles 节点是否存在
# 在~/.config/Code/User/globalStorage/storage.json中
# 如果没有创建任何一个自定义Profile，storage.json中的userDataProfiles节点是不存在的
# 参数：storage.json文件路径，如果不给，则使用默认值
# 返回：存在为true，反之为false
function exists_userdataprofile_node() {

	# storage.json文件路径
	local storage_file=$1
	if [[ $# -eq 0 ]]; then
		storage_file="$HOME/.config/Code/User/globalStorage/storage.json"
	fi

	local exists_result=$(jq 'has("userDataProfiles")' $storage_file)

	# 返回检测结果
	echo $exists_result
}

# 创建一个Profile
# 参数：Profile 名称
function create_profile() {

	# Profile 名称
	local profile_name=$1

	# storage.json文件路径
	local storage_file="$HOME/.config/Code/User/globalStorage/storage.json"

	if [[ $# -eq 0 ]]; then
		echo -e "\e[93m请给一个要创建的 Profile 名称！\n \e[0m"
		return
	fi

	# 检测 storage.json文件中 userDataProfiles 节点是否存在
	# 如果一个自定义的Profile都没有创建，userDataProfile 节点是不存在的
	local userDataProfiles_exists=$(jq 'has("userDataProfiles")' $storage_file)

	if $userDataProfiles_exists; then
		# 检测 Profile 是否已经创建
		local profile_exists=$(jq --arg p_name $profile_name '.userDataProfiles[] | .name==$p_name' $storage_file)

		if $profile_exists; then
			# echo -e "\e[36m$profile_name \e[93mProfile已经存在，无须再创建！\e[0m"
			echo -e "\e[96m$profile_name \e[93mProfile已经存在，无须再创建！\e[0m"
		else
			# 创建 Profile
			echo -e "\e[92m创建Profile \e[96m$profile_name \e[92m... \e[0m"
			code --profile "$profile_name"
		fi
	else
		# 创建 Profile
		echo -e "\e[92m创建Profile \e[96m$profile_name \e[92m... \e[0m"
		code --profile "$profile_name"
	fi

}

# 通过Profile 名称获取Profile的location值
# Profile 的location值就是Profile存储目录的目录名
# ~/.config/Code/User/profiles/profile location/
# 参数1：Profile 名称
# 返回：Profile location 值
function getProfileLocationByProfileName() {

	# storage.json文件路径
	local storage_file="$HOME/.config/Code/User/globalStorage/storage.json"

	# Profile 名称
	local profile_name=$1

	local profile_location

	# jq -r '.userDataProfiles[] | .name="Test_Profile"|.location' ~/.config/Code/User/globalStorage/storage.json

	# 获取 Profile location 值
	profile_location=$(jq -r --arg p_name $profile_name '.userDataProfiles[] | .name=$p_name |.location' $storage_file)

	# 返回 Profile location值
	echo $profile_location

}

# 读取扩展列表并解析
# 可以接收多个扩展列表文件
# 每个参数都是一个扩展列表文件路径
# 返回扩展id数组
function read_extension_list() {

	# 扩展 uid 数组
	local exuid_arr=()

	# 多个扩展列表文件
	for exlist_path in "$@"; do

		# 保证扩展列表存在
		if [ -f "$exlist_path" ]; then

			# 过滤掉空行及使用#注释的行
			for line in $(cat $exlist_path | grep -v ^$ | grep -v ^\#); do
				# 把每行扩展的 uid 存储进数组中
				exuid_arr+=($line)
				# echo $line
			done
		fi
	done

	# 返回 扩展uid 数组
	echo "${exuid_arr[@]}"
	# echo "${exuid_arr[@]}"

}

# 安装单个扩展
# 安装到默认Profile
# 参数：扩展id
function install_extension() {
	# 扩展的UID，即 Unique Identifier
	local extension_uid=$1

	# 安装
	code --install-extension $extension_uid

}

# 为某Profile安装单个扩展
# 参数1: Profile 名称
# 参数2: 扩展id
function install_extension_profile() {

	# Profile 名称
	local profile_name=$1

	# 扩展的UID，即 Unique Identifier
	local extension_uid=$2

	# 判断参数是否给全
	if [[ $# -lt 2 ]]; then
		echo -e "\e[93m请给出Profile名称及扩展id！\n \e[0m"
		return
	fi

	# 安装扩展
	code --profile $profile_name --install-extension $extension_uid

}
# 为默认Profile批量安装扩展
# 参数：扩展id数组
function install_batch() {

	# 扩展 uid 数组
	local exuid_arr=($@)

	# echo ${exuid_arr[@]}

	if [ ${#exuid_arr[@]} -eq 0 ]; then
		echo -e "\e[93m扩展列表为空！\e[96m...\n \e[0m"
	else
		for exui in "${exuid_arr[@]}"; do
			# 安装
			install_extension $exui
			sleep 0.01
		done
	fi

}

# 为某Profile批量安装扩展
# 参数1：Profile 名称
# 参数2：扩展id数组
function install_batch_profile() {

	# 判断参数是否给全
	if [[ $# -lt 2 ]]; then
		echo -e "\e[93m请给出Profile名称及扩展id！\n \e[0m"
		return
	fi

	# Profile 名称
	local profile_name=$1

	# 移除第一个参数
	shift

	# 扩展 uid 数组
	local exuid_arr=($@)

	# echo ${exuid_arr[@]}

	if [ ${#exuid_arr[@]} -eq 0 ]; then
		echo -e "\e[93m扩展列表为空！\e[96m...\n \e[0m"
	else
		for exui in "${exuid_arr[@]}"; do
			# 为Profile安装扩展
			# install_extension $exui
			install_extension_profile $profile_name $exui
			sleep 0.01
		done
	fi

}
# 打印出插件数组
# 参数是一个数组
function print_exarr() {

	local exlist_arr=($@)

	# echo ${exlist_arr[@]}

	for ex_temp in "${exlist_arr[@]}"; do
		echo -e "\e[94m* \e[96m$ex_temp \e[0m"
	done

}

################################测试################################

# 测试 install_extension 函数
# install_extension "formulahendry.code-runner"
# install_extension $1

# --------------------------------------------------

# 测试读取扩展列表函数
# arr_t1=($(read_extension_list $1))
# read_extension_list $1

# 查看数组元素个数
# echo ${#arr_t1[@]}

# echo $arr_t1
# echo ${arr_t1[@]}

# echo "----------------------------"

# 打印出数组元素
# for a_temp in ${arr_t1[@]}; do
# 	echo $a_temp
# done

# --------------------------------------------------

# 测试批量安装扩展
# 获取扩展uid列表并构建成数组
# arr_t1=($(read_extension_list $1))
# echo ${arr_t1[@]}
# 进行批量安装
# install_batch ${arr_t1[@]}

# --------------------------------------------------

# 测试检测userDataProfiles节点是否存在的函数
# exists_userdataprofile_node
# exists_userdataprofile_node $HOME/.config/Code/User/globalStorage/storage.json

# --------------------------------------------------

# 测试创建Profile
# create_profile
# create_profile Test_Profile

# --------------------------------------------------

# 测试为某Profile安装扩展

# install_extension_profile
# install_extension_profile Test_Profile
# install_extension_profile Test_Profile redhat.java

# --------------------------------------------------

# 测试为某Profile 批量安装扩展
# install_batch_profile
# install_batch_profile Test_Profile
# install_batch_profile Test_Profile redhat.java
# install_batch_profile Test_Profile redhat.java eamodio.gitlens
