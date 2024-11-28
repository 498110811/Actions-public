# Modify default theme 设置默认主题，一般不用
sed -i 's/luci-theme-bootstrap/luci-theme-design/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-design/g' feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-design/g' feeds/luci/collections/luci-ssl-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-design/g' feeds/luci/collections/luci-light/Makefile

# Modify default IP（修改wan口IP）本地编译时在文件的第150行左右
sed -i 's/192.168.1.1/192.168.68.1/g' package/base-files/files/bin/config_generate

# 新版LUCI的ip修改地址
# sed -i 's/192.168.1.1/192.168.68.1/g' package/base-files/luci2/bin/config_generate

# 更新为root用户的默认密码为【admin】
# sed -i 's|root:::0:99999:7:::|root:$1$ZrdSUj0o$MjkG92YkikpJJ4LHXI8uT1:20013:0:99999:7:::|g' package/base-files/files/etc/shadow
# 可选密码
# root:$1$ZrdSUj0o$MjkG92YkikpJJ4LHXI8uT1:20013:0:99999:7:::【admin】
# root:$1$d.4wFNEh$eGr/CydIez04zsnfDdqPa0:20013:0:99999:7:::【root】

# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by LEDE/g" package/lean/default-settings/files/zzz-default-settings


# 修改主机名以及一些显示信息
sed -i "s/hostname='*.*'/hostname='Cyber_3588_AIB'/" package/base-files/files/bin/config_generate
#sed -i "s/DISTRIB_ID='*.*'/DISTRIB_ID='OpenWrt'/g" package/base-files/files/etc/openwrt_release
#sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt'/g"  package/base-files/files/etc/openwrt_release
#sed -i '/(<%=pcdata(ver.luciversion)%>)/a\      built by test' package/lean/autocore/files/x86/index.htm
#echo -n "$(date +'%Y%m%d')" > package/base-files/files/etc/openwrt_version
#curl -fsSL https://raw.githubusercontent.com/ywt114/diy/main/banner_test > package/base-files/files/etc/banner

# 开启wifi选项
sed -i 's/disabled=*.*/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/ssid=*.*/ssid=Cyber_3588_AIB/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 设置wifi加密方式为psk2+ccmp,wifi密码为88888888
sed -i 's/encryption=none/encryption=psk2+ccmp/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${devidx}.encryption=psk2+ccmp/a\\t\t\tset wireless.default_radio${devidx}.key=88888888' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 设置无线的国家代码为CN,wifi的默认功率为20
sed -i 's/country=US/country=CN/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.radio${devidx}.disabled=0/a\\t\t\tset wireless.radio${devidx}.txpower=20' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 设置wan口上网方式为PPPOE，本地编译时在文件的第86行左右
# sed -i 's/2:-dhcp/2:-pppoe/g' package/base-files/files/lib/functions/uci-defaults.sh
# 设置PPPOE上网的账号和密码,本地编译时在文件的第182和183行左右
# sed -i 's/username='"'"'username'"'"'/username='"'"'403'"'"'/g; s/password='"'"'password'"'"'/password='"'"'8888'"'"'/g' package/base-files/files/bin/config_generate

# 设置默认开启MU-MIMO
# sed -i '/set wireless.radio${devidx}.disabled=0/a\\t\t\tset wireless.radio${devidx}.mu_beamformer=1' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# TTYD 免登录
# sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 删除ipv6前缀
#sed -i 's/auto//' package/base-files/files/bin/config_generate

# 在线用户
sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=2s' package/lean/default-settings/files/zzz-default-settings
sed -i '$i uci commit nlbwmon' package/lean/default-settings/files/zzz-default-settings
chmod 755 package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh

# 移除要替换的包
#rm -rf feeds/packages/net/mosdns
#rm -rf feeds/packages/net/msd_lite
#rm -rf feeds/packages/net/smartdns
#rm -rf feeds/luci/themes/luci-theme-argon
#rm -rf feeds/luci/themes/luci-theme-argon-mod
#rm -rf feeds/luci/applications/luci-app-argon-config
#rm -rf feeds/luci/themes/luci-theme-netgear
#rm -rf feeds/luci/applications/luci-app-mosdns
#rm -rf feeds/luci/applications/luci-app-netdata
#rm -rf feeds/luci/applications/luci-app-serverchan
#rm -rf feeds/package/helloworld
#rm -rf feeds/packages/lang/golang
#rm -rf feeds/packages/net/v2ray-geodata

#修改应用名称
replace_text() {
  search_text="$1" new_text="$2"
  sed -i "s/$search_text/$new_text/g" $(grep "$search_text" -rl ./ 2>/dev/null) || echo -e "\e[31mNot found [$search_text]\e[0m"
}

replace_text "Turbo ACC 网络加速" "网络加速"
replace_text "移动网络" "蜂窝"
