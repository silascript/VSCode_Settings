#          ╭──────────────────────────────────────────────────────────╮
#          │						核心函数                          │
#          ╰──────────────────────────────────────────────────────────╯

# 安装扩展
function install_extension() {
	# 扩展的UID，即 Unique Identifier
	local extension_uid=$1

	# 安装
	code --install-extension $extension_uid

}

# 读取扩展列表
function read_extension_list() {

	# 列表路径
	local exlist_path=$1
	# 扩展 uid 数组
	local exuid_arr=()

	# 过滤掉空行及使用#注释的行
	for line in $(cat $exlist_path | grep -v ^$ | grep -v ^\#); do
		# 把每行扩展的 uid 存储进数组中
		exuid_arr+=($line)
		# echo $line
	done

	# 返回 扩展uid 数组
	# echo "${exuid_arr[@]}"

	echo ${exuid_arr[@]}
	# echo "${exuid_arr[*]}"
	# echo $exuid_arr

}

# function test1(){
# 	local array1=(2 5 22 32 18)
#
# 	# echo ${#array1[@]}
#
# 	echo ${array1[@]}
# }

################################测试################################

# 测试 install_extension 函数
# install_extension "formulahendry.code-runner"
# install_extension $1

# --------------------------------------------------

# 测试读取扩展列表函数
arr_t1=($(read_extension_list $1))
# read_extension_list $1

# 查看数组元素个数
echo ${#arr_t1[@]}

# echo $arr_t1
echo ${arr_t1[@]}

echo "----------------------------"

# 打印出数组元素
for a_temp in ${arr_t1[@]}; do
	echo $a_temp
done

# --------------------------------------------------
# 测试 test1 函数
# 获取返回值次构建为数组
# r_arr=($(test1))
# echo ${#r_arr[@]}
# echo $r_arr
