#!/bin/bash

set -e

#/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $1" ./EFB/Info.plist
#echo "Updated CFBundleVersion to $NEW_VERSION"
sed -i '' "s/MARKETING_VERSION = .*/MARKETING_VERSION = $1;/" \
    ./EFB.xcodeproj/project.pbxproj
echo "Version set to $1"
WORKING_LOCATION="$(pwd)"
APPLICATION_NAME=EFB

if [ ! -d "build" ]; then
    mkdir build
fi
rm -rf ./build/DerivedDataApp
cd build

xcodebuild -project "$WORKING_LOCATION/$APPLICATION_NAME.xcodeproj" \
    -scheme "$APPLICATION_NAME" \
    -configuration Debug \
    -derivedDataPath "$WORKING_LOCATION/build/DerivedDataApp" \
    -destination 'generic/platform=iOS' \
    clean build \
    ONLY_ACTIVE_ARCH="NO" \
    CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO" \

DD_APP_PATH="$WORKING_LOCATION/build/DerivedDataApp/Build/Products/Debug-iphoneos/$APPLICATION_NAME.app"
TARGET_APP="$WORKING_LOCATION/build/$APPLICATION_NAME.app"
cp -r "$DD_APP_PATH" "$TARGET_APP"

codesign --remove "$TARGET_APP"
if [ -e "$TARGET_APP/_CodeSignature" ]; then
    rm -rf "$TARGET_APP/_CodeSignature"
fi
if [ -e "$TARGET_APP/embedded.mobileprovision" ]; then
    rm -rf "$TARGET_APP/embedded.mobileprovision"
fi
echo Building iPA
mkdir Payload
cp -r $APPLICATION_NAME.app Payload/$APPLICATION_NAME.app
zip -vr EFB.ipa Payload
rm -rf $APPLICATION_NAME.app
rm -rf Payload
rm -rf DerivedDataApp
