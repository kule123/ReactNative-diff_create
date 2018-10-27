#!/bin/bash


#计时
SECONDS=0

#指定工程文件路径
project_path="./QEZB1.0.0"
#指定工程plist文件路径
exportPlist_path="./QEZB1.0.0/QEZB/Macro/exportPlist.plist"

#取当前时间字符串添加到文件结尾
now=$(date +%Y_%m_%d_%H_%M_%S)

#指定项目的scheme名称
scheme="QEZB"
#指定项目要打包的配置名
configuration="Release"
#指定打包所使用的provisioning profile名称
provisioning_profile='QIETVDevelopmentNEWNEW'


#指定项目地址
workspace_path="$project_path/QEZB.xcworkspace"
#指定输出路径
output_path="/Users/liuwei/Desktop/ipa/3.8.x/dev"
#指定输出归档文件地址
archive_path="$output_path/QEZB_${now}.xcarchive"
#指定输出ipa地址
ipa_path="$output_path/QEZB_${now}/"
#获取执行命令时的commit message
commit_msg="$1"
#指定日志输出路径
output_log_path="~/Desktop/ipa/changelog.txt"


#输出设定的变量值
echo "===workspace path: ${workspace_path}==="
echo "===archive path: ${archive_path}==="
echo "===ipa path: ${ipa_path}==="
echo "===profile: &{provisioning_profile}==="
echo "===commit msg: $1==="


#rn bundle包自动更新   开始
echo "===rn bundle update start==="
mainBundle="../qieios/QEZB1.0.0/QEZB1.0.0/bundle.zip"
bundle=../../ios

if [ -d "${bundle}" ]; then
rm -rf ${bundle}
fi

mkdir ${bundle}
react-native bundle --platform ios --assets-dest ${bundle} --dev false --entry-file index.ios.js --bundle-output ${bundle}/main.jsbundle

cd ${bundle}
zipFile=bundle.zip
zip -r ${zipFile} assets main.jsbundle
mv ${zipFile} ${mainBundle}

cd "../qieios/QEZB1.0.0"

echo "===rn bundle update end==="
#rn bundle包自动更新   结束

#输出总用时
echo "===Finished. Total time: ${SECONDS}s==="
