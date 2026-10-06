#echo $PWD
# 获取当前脚本绝对路径
# echo $(
# 	cd $(dirname $0)
# 	pwd
# )

# getopts

t1() {

	# echo $0
	# 第一个参数是 Profile 名称
	local profile_name=$1
	local extension_id=$2

	# -n Profile的名称 -e 插件id
	# while getopts 'n:e' OPT; do
	# 	case $OPT in
	# 	n)
	# 		profile_name="$OPTARG"
	# 		;;
	# 	e)
	# 		extension_id="$OPTARG"
	# 		;;
	# 	esac
	# done

	# 检测 userDataProfiles 节点是否存在
	local ise=$(jq 'has("userDataProfiles")' ~/.config/Code/User/globalStorage/storage.json)
	if $ise; then
		# 检测 Profile 是否已经创建
		local profile_exists=$(jq --arg p_name $profile_name '.userDataProfiles[] | .name==$p_name' ~/.config/Code/User/globalStorage/storage.json)

		if $profile_exists; then
			# 为已创建的 Profile 安装插件
			code --profile "$profile_name" --install-extension $extension_id
		else
			# 创建 Profile
			code --profile "$profile_name"
		fi
	else
		# 创建 Profile
		code --profile "$profile_name"
	fi

}

# 读取扩展列表并解析
# 可以接收多个扩展列表文件
# 每个参数都是一个扩展列表文件路径
# 返回扩展id
function t2() {

	# 扩展 uid 数组
	local exuid_arr=()

	# 多个扩展列表文件
	for exlist_path in "$@"; do

		# 保证扩展列表存在
		if [ -f "$exlist_path" ]; then

			# 过滤掉空行及使用#注释的行
			# for line in $(cat $exlist_path | grep -v ^$ | grep -v ^\#); do
			# 把每行扩展的 uid 存储进数组中
			# exuid_arr+=($line)
			# echo $line
			# done

			cat $exlist_path | grep -v ^$ | grep -v ^\# | xargs echo

		fi
	done

	# 返回 扩展uid 数组
	# echo "${exuid_arr[@]}"

}

# ///////////////////////////////测试///////////////////////////////

# 测试 t1函数
# t1 "$@"

# ////////////////////////////////////////////////////////////////////

# 测试 t2函数
# 构建成一个数组
exid_arr=($(t2 ./Extension_List/exlist_default.txt ./Extension_List/exlist_java.txt))
# exid_arr=($(t2 ./Extension_List/exlist_default.txt))

# 数组数量
echo ${#exid_arr[@]}

# 显示数组每个元素
echo "${exid_arr[@]}"



