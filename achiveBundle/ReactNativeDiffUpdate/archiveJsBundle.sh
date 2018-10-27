#!/bin/bash

#rn bundle包自动更新   开始
echo "===rn bundle update start==="
mainBundle="../desktop/(project_name)/(project_name)/bundle.zip"
bundle=../../ios
#
if [ -d "${bundle}" ]; then
rm -rf ${bundle}
fi
#
mkdir ${bundle}
react-native bundle --platform ios --assets-dest ${bundle} --dev false --entry-file index.ios.js --bundle-output ${bundle}/main.jsbundle
#
cd ${bundle}
zipFile=bundle.zip
zip -r ${zipFile} assets main.jsbundle
mv ${zipFile} ${mainBundle}
#
cd "../desktop/(project_name)"
#
echo "===rn bundle update end==="
#rn bundle包自动更新   结束



