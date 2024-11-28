# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# 添加额外插件
git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash package/luci-app-openclash
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall luci-app-passwall package/luci-app-passwall
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall2 luci-app-passwall2 package/luci-app-passwall2
git clone https://github.com/sirpdboy/luci-app-lucky.git package/luci-app-lucky

# iStore
git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
git_sparse_clone main https://github.com/linkease/istore luci

# 在线用户
git_sparse_clone main https://github.com/haiibo/packages luci-app-onliner
sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=2s' package/lean/default-settings/files/zzz-default-settings
sed -i '$i uci commit nlbwmon' package/lean/default-settings/files/zzz-default-settings
chmod 755 package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh

# Add a feed source
# echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >>feeds.conf.default
# echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default

# 这个passwall经测试，用不了
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# 大插件包
# echo 'src-git smpackage https://github.com/kenzok8/small-package' >>feeds.conf.default

# 小插件包
# echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >>feeds.conf.default
# echo 'src-git small https://github.com/kenzok8/small' >>feeds.conf.default
# echo 'src-git pkg https://github.com/1774293824/openwrt-pkg' >>feeds.conf.default
sed -i 's/coolsnowwolf\/luci.git;openwrt-23.05/498110811\/luci.git/g' feeds.conf.default
sed -i "/src-git modem /d; 1 i src-git modem https://github.com/FUjr/modem_feeds.git" feeds.conf.default
