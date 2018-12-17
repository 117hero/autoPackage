#! /bin/bash
# created by Chen
#工程绝对路径
project_path=/Users/wjy/Desktop/XXX
#工程名称
project_name=XXX
#scheme名
scheme_name=XXX
#archive文件夹名称
archive_path=/Users/wjy/Desktop/packageManager
#导出.ipa文件所在路径
exportFilePath=/Users/wjy/Desktop/packageManager/${scheme_name}_IPA
echo "Place enter the number you want to export ? [ 1:app-store 2:ad-hoc] "
read number
while([[ $number != 1 ]] && [[ $number != 2 ]])
do
  echo "Error! Should enter 1 or 2"
  echo "Place enter the number you want to export ? [ 1:app-store 2:ad-hoc] "
  read number
done
if [ $number == 1 ];then
  development_mode=Release
  exportOptionsPlistPath=/Users/wjy/Desktop/packageManager/ExportOptions_appstore.plist
else
  development_mode=Debug
  exportOptionsPlistPath=/Users/wjy/Desktop/packageManager/ExportOptions_ad_hoc.plist
fi

echo '*** 正在 编译工程 For '${development_mode}
xcodebuild \
  archive \
  -workspace ${project_path}/${project_name}.xcworkspace \
  -scheme ${scheme_name} \
  -configuration ${development_mode} \
  -archivePath ${archive_path}/${project_name}.xcarchive \
  clean archive \
  -quiet || exit
echo '*** 编译完成 ***'
echo '*** 正在 打包 ***'
xcodebuild \
  -exportArchive \
  -archivePath ${archive_path}/${project_name}.xcarchive \
  -exportPath ${exportFilePath} \
  -exportOptionsPlist ${exportOptionsPlistPath} \
  -allowProvisioningUpdates \
  -quiet || exit
if [ -e $exportFilePath/$scheme_name.ipa ]; then
    echo "*** .ipa文件已导出 ***"
      open $exportFilePath
    else
        echo "*** 创建.ipa文件失败 ***"
      fi
      echo '*** 打包完成 ***'

if [ $number == 1 ];then
# 上传IPA到App Store
echo '/// 开始上传到App Store '
# 将-u 后面的XXX替换成自己的AppleID的账号，-p后面的XXX替换成自己的密码
altoolPath="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
"$altoolPath" --validate-app -f ${exportFilePath}/${scheme_name}.ipa -u XXX -p XXX -t ios --output-format xml
"$altoolPath" --upload-app -f ${exportFilePath}/${scheme_name}.ipa -u XXX -p XXX -t ios --output-format xml
else
# 上传IPA到蒲公英
echo '/// 开始上传到蒲公英 '
curl -F "file=@/Users/wjy/Desktop/packageManager/XXX_IPA/XXX.ipa" \
  -F "uKey=XXX" \
  -F "_api_key=XXX" \
  https://www.pgyer.com/apiv1/app/upload
fi
exit 0
