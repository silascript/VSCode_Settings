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

# ///////////////////////////////测试///////////////////////////////

t1 "$@"
