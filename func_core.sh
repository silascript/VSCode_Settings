#          ╭──────────────────────────────────────────────────────────╮
#          │						核心函数                          │
#          ╰──────────────────────────────────────────────────────────╯

# 读取扩展列表
function read_extension_list() {

	# 列表路径
	local exlist_path=$1
	# 扩展 uid 数组
	local exuid_arr=()

	# 保证扩展列表存在
	if [ -f "$exlist_path" ]; then

		# 过滤掉空行及使用#注释的行
		for line in $(cat $exlist_path | grep -v ^$ | grep -v ^\#); do
			# 把每行扩展的 uid 存储进数组中
			exuid_arr+=($line)
			# echo $line
		done
	fi

	# 返回 扩展uid 数组
	echo ${exuid_arr[@]}
	# echo "${exuid_arr[@]}"

}

# 安装扩展
function install_extension() {
	# 扩展的UID，即 Unique Identifier
	local extension_uid=$1

	# 安装
	code --install-extension $extension_uid

}

# 批量安装扩展
# 参数为扩展数组
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
