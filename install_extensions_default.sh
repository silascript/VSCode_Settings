#          ╭──────────────────────────────────────────────────────────╮
#          │                 为默认Profile安装扩展                    │
#          ╰──────────────────────────────────────────────────────────╯

#####################################################################
# 引入核心函数脚本
source ./func_core.sh

#####################################################################

# 安装默认扩展
function install_default_extensions() {

	# 默认扩展uid列表路径
	local exlist_defualt_path=./Extension_List/exlist_default.txt
	# 扩展uid列表路径
	local exlist_path=$1

	# 判断扩展uid列表路径
	# 如果没接收到实参，则设置一个默认值
	if [ -z "$exlist_path" ]; then
		exlist_path=$exlist_defualt_path
	fi

	# 获取扩展uid列表并构建成数组
	arr_t1=($(read_extension_list $exlist_path))
	# echo ${arr_t1[@]}

	echo "开始安装插件..."
	# 进行批量安装
	install_batch ${arr_t1[@]}

	echo "所有插件安装完毕!"
}

#####################################################################

# 复制配置文件settings到指定目录
function cp_settings() {

	# 将默认Profile的Settings复制到指定目录:~/.config/Code/User/
	echo "复制settings..."
	cp -v ./default_settings.json ~/.config/Code/User/settings.json

	# 将默认快捷键配置复制到指定目录:~/.config/Code/User/
	cp -v ./default_keybindings.json ~/.config/Code/User/keybindings.json

	if [ $? -eq 0 ]; then
		echo "settings复制成功！"
	else
		echo "settings复制失败！"
	fi
}

# 初始化默认Profile
function init_default() {

	# 默认Profile 扩展uid列表路径
	local default_exlist_path=$1

	# 安装默认扩展
	install_default_extensions $default_exlist_path
	# 复制默认settings
	cp_settings
}

#####################################################################

# install_default_extensions $1
init_default $1
