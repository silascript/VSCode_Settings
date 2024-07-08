echo "开始安装插件..."

# 安装简繁体中文语言包
code --install-extension MS-CEINTL.vscode-language-pack-zh-hans
code --install-extension MS-CEINTL.vscode-language-pack-zh-hant

# 安装简繁转换插件
code --install-extension Compulim.vscode-chinese-translation

# 安装 字体选择 插件
code --install-extension evan-buss.font-switcher

# 安装 vim 插件
code --install-extension vscodevim.vim

# 安装 Catppuccin 主题
code --install-extension Catppuccin.catppuccin-vsc

# 安装 Icons
code --install-extension thang-nm.catppuccin-perfect-icons

# 安装 路径提示 插件
code --install-extension christian-kohler.path-intellisense

# 安装BookMark 插件
code --install-extension alefragnani.Bookmarks

# 安装 项目管理 插件
code --install-extension alefragnani.project-manager

# 安装 Error Lens 插件
code --install-extension usernamehw.errorlens

# 安装 注释 插件
code --install-extension aaron-bond.better-comments

# 安装 代码阅读 Aide 插件
# code --install-extension nicepkg.aide-pro

echo "所有插件安装完毕!"

# 将默认Profile的Settings复制到指定目录:~/.config/Code/User/
echo "复制settings..."
cp -v ./default_settings.json ~/.config/Code/User/settings.json

if [ $? == 0 ]; then
	echo "settings复制成功！"
else
	echo "settings复制失败！"
fi
