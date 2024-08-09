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

################################测试################################

# 测试 install_extension 函数
# install_extension "formulahendry.code-runner"
# install_extension $1
