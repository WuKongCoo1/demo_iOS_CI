#!/bin/sh

### 配置定义
PROJECT_NAME="test"

# 获取当前脚本路径
# basepath=$(cd `dirname $0`; pwd)

CONFIGURATION="Debug"

#工程名
WORKSPACE="demo.xcworkspace"

#设置打包路径
PACKAGE_PATH="Package"

#archive path
XCARCHIVE_PATH="${PACKAGE_PATH}/xcarchive/${PROJECT_NAME}.xcarchive"

#ipa 路径
IPA_Path="${PACKAGE_PATH}/ipa"

#ipa名称
IPAFILE_NAME="${PROJECT_NAME}.ipa"

#导出ipa路径
EXPORT_PATH="${IPA_Path}/${IPAFILE_NAME}"

optionPlistName="ExportOptions_development"

# clean
echo "xcodebuild clean"
xcodebuild clean -workspace ${WORKSPACE} \
             	   -scheme ${PROJECT_NAME} \
                 -configuration ${CONFIGURATION} \
                 | xcpretty 

# archive
echo "xcodebuild archive"
xcodebuild archive -workspace ${WORKSPACE} \
                   -scheme ${PROJECT_NAME} \
                   -configuration ${CONFIGURATION} \
                   -destination generic/platform=iOS \
                   -archivePath ${XCARCHIVE_PATH} \
                   | xcpretty 
                   

# test
xcodebuild  test -workspace ${WORKSPACE} \
                 -scheme ${PROJECT_NAME} \
                 -sdk iphonesimulator \
                 -destination 'platform=iOS Simulator,name=iPhone 8' \
                | xcpretty 

# export ipa
echo "xcodebuild exportArchive"
xcodebuild -exportArchive -archivePath ${XCARCHIVE_PATH} \
                          -exportPath ${EXPORT_PATH} \
                          -exportOptionsPlist ${optionPlistName}.plist \
                          -verbose \
                          | xcpretty 
                          
