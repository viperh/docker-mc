#!/bin/bash

version=${VERSION}
build=${BUILD}
eula=${EULA}
url_versions="https://api.papermc.io/v2/projects/paper"
latest_version=""
latest_build=""

echo "Version $version"
echo "Build $build"
echo "Eula $eula"









if [ "$version" = "latest" ]; then
    response=$(curl -s "$url_versions")
    latest_version=$(jq -r '.versions | last' <<< "$response")
    echo "Latest version: $latest_version"
else
    latest_version=$version
fi


if [ "$build" = "latest" ]; then
    url_builds="https://api.papermc.io/v2/projects/paper/versions/$latest_version/"
    response=$(curl -s "$url_builds")
    latest_build=$(jq -r '.builds | last' <<< "$response")
    echo "Latest build: $latest_build"
else
    latest_build=$build
fi



name_url="https://api.papermc.io/v2/projects/paper/versions/$latest_version/builds/$latest_build"

response=$(curl -s $name_url)
file_name=$(echo "$response" | jq -r '.downloads.application.name')


final_url="https://api.papermc.io/v2/projects/paper/versions/$latest_version/builds/$latest_build/downloads/$file_name"

echo "Downloading from url: $final_url"

if [ -e $file_name ]; then
    echo "INFO: paper.jar already found in current directory. skipping download..."
else
    echo "Downloading Paper version $latest_version, build $latest_build..."
    curl -o $file_name $final_url

    java -jar $file_name
    
    clear

    if [ "$eula" = "true" ]; then
        rm -f eula.txt
        echo "eula=true" > eula.txt
    else
        echo "WARNING: YOU HAVE TO ACCEPT EULA TO CONTINUE! SET EULA=TRUE ENV VAR!"
    fi

    java -jar $file_name


fi







