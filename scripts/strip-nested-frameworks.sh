removeFrameworks () {
  find "$1" -name "*.$2" -type d | while read -r FRAMEWORK
do
    FRAMEWORK_FRAMEWORKS="$FRAMEWORK/Frameworks"
    if [[ -d $FRAMEWORK_FRAMEWORKS ]]
then
    echo "Removing nested framework: $FRAMEWORK_FRAMEWORKS"
    rm -rf $FRAMEWORK_FRAMEWORKS
fi
done
}

APP_FRAMEWORKS="${TARGET_BUILD_DIR}/${WRAPPER_NAME}/Frameworks"
removeFrameworks $APP_FRAMEWORKS "framework"

APP_PLUGINS="${TARGET_BUILD_DIR}/${WRAPPER_NAME}/PlugIns"
removeFrameworks $APP_PLUGINS "appex"

TARGETS=$(xcrun xcodebuild -list -json | tr -d '\n' | tr -d ' ' | tr -d ',' | sed -e 's/.*targets"\(.*\)].*/\1/' | grep -Eo '["](.*)["]' | sed -e 's/\"\"/,/g' | tr -d '"')

ARRAY=($(echo "$TARGETS" | tr ',' '\n'))
for i in "${!ARRAY[@]}"
do
        APP_PLUGIN="${TARGET_BUILD_DIR}/${ARRAY[i]}.appex"
        if [[ -d $APP_PLUGIN ]]
then
    removeFrameworks $APP_PLUGIN "appex"
fi
        APP_FRAMEWORK="${TARGET_BUILD_DIR}/${ARRAY[i]}.framework"
        if [[ -d $APP_FRAMEWORK ]]
then
    removeFrameworks $APP_FRAMEWORK "framework"
fi

done
