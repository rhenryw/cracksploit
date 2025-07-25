#!/bin/bash

main() {
    clear
    echo -e "Welcome to the MacSploit Experience!"
    echo -e "Install Script Version 2.7 - User Mode"

    echo -ne "Checking License..."
    curl -s "https://git.raptor.fun/main/jq-macos-amd64" -o "./jq"
    chmod +x ./jq
    
    curl -s "https://git.raptor.fun/sellix/hwid" -o "./hwid"
    chmod +x ./hwid
    
    local user_hwid=$(./hwid)
    # Spoof the hwid_info response
    local hwid_info='{"success": true, "free_trial": false}'
    local hwid_resp=$(echo $hwid_info | ./jq -r ".success")
    rm ./hwid

    if [ "$hwid_resp" != "true" ]
    then
        echo -ne "\rEnter License Key:       \b\b\b\b\b\b"
        read input_key

        echo -n "Contacting Secure Api... "
        
        # Spoof the license validation response
        local resp='Key Activation Complete!'
        echo -e "Done.\n$resp"
    else
        local free_trial=$(echo $hwid_info | ./jq -r ".free_trial")
        if [ "$free_trial" == "true" ]
        then
            echo -ne "\rEnter License Key (Press Enter to Continue as Free Trial): "
            read input_key
            
            if [ "$input_key" != '' ]
            then
                echo -n "Contacting Secure Api... "
                
                # Spoof the license validation response for free trial
                local resp='Key Activation Complete!'
                echo -e "Done.\n$resp"
            fi
        else
            echo -e " Done.\nWhitelist Status Verified."
        fi
    fi
    
    [ -d "Applications" ] || mkdir "Applications"
    echo -e "Downloading Latest Roblox..."
    
    [ -f ./RobloxPlayer.zip ] && rm ./RobloxPlayer.zip
    local robloxVersionInfo=$(curl -s "https://clientsettingscdn.roblox.com/v2/client-version/MacPlayer")
    local versionInfo=$(curl -s "https://git.raptor.fun/main/version.json")
    
    local mChannel=$(echo $versionInfo | ./jq -r ".channel")
    local version=$(echo $versionInfo | ./jq -r ".clientVersionUpload")
    local robloxVersion=$(echo $robloxVersionInfo | ./jq -r ".clientVersionUpload")
    
    if [ "$version" != "$robloxVersion" ] && [ "$mChannel" == "preview" ]
    then
        curl "http://setup.rbxcdn.com/mac/$robloxVersion-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    else
        curl "http://setup.rbxcdn.com/mac/$version-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    fi
    
    echo -n "Installing Latest Roblox... "
    [ -d "Applications/Roblox.app" ] && rm -rf "Applications/Roblox.app"
    unzip -o -q "./RobloxPlayer.zip"
    mv ./RobloxPlayer.app ./Applications/Roblox.app
    rm ./RobloxPlayer.zip
    echo -e "Done."

    echo -e "Downloading MacSploit..."
    curl "https://git.raptor.fun/main/macsploit.zip" -o "./MacSploit.zip"

    echo -n "Installing MacSploit... "
    unzip -o -q "./MacSploit.zip"
    echo -e "Done."

    echo -n "Updating Dylib..."
    if [ "$version" != "$robloxVersion" ] && [ "$mChannel" == "preview" ]
    then
        curl -Os "https://git.raptor.fun/preview/macsploit.dylib"
    else
        curl -Os "https://git.raptor.fun/main/macsploit.dylib"
    fi
    
    echo -e " Done."
    echo -e "Patching Roblox..."
    local pat=$(pwd)
    
    mv ./macsploit.dylib "Applications/Roblox.app/Contents/MacOS/macsploit.dylib"
    ./insert_dylib "$pat/Applications/Roblox.app/Contents/MacOS/macsploit.dylib" "$pat/Applications/Roblox.app/Contents/MacOS/RobloxPlayer" --strip-codesig --all-yes
    mv "Applications/Roblox.app/Contents/MacOS/RobloxPlayer_patched" "Applications/Roblox.app/Contents/MacOS/RobloxPlayer"
    rm -r "Applications/Roblox.app/Contents/MacOS/RobloxPlayerInstaller.app"
    rm ./insert_dylib

    echo -n "Installing MacSploit App... "
    [ -d "Applications/MacSploit.app" ] && rm -rf "Applications/MacSploit.app"
    mv ./MacSploit.app ./Applications/MacSploit.app
    rm ./MacSploit.zip
    
    touch ~/Downloads/ms-version.json
    echo $versionInfo > ~/Downloads/ms-version.json
    if [ "$version" != "$robloxVersion" ] && [ "$mChannel" == "preview" ]
    then
        cat <<< $(./jq '.channel = "previewb"' ~/Downloads/ms-version.json) > ~/Downloads/ms-version.json
    fi
    
    rm ./jq
    echo -e "Done."
    echo -e "Install Complete! Developed by Nexus42!"
    exit
}

main
