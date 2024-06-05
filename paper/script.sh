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
else
    latest_build=$build
fi



name_url="https://api.papermc.io/v2/projects/paper/versions/$latest_version/builds/$latest_build"

response=$(curl -s $name_url)
file_name=$(echo "$response" | jq -r '.downloads.application.name')


final_url="https://api.papermc.io/v2/projects/paper/versions/$latest_version/builds/$latest_build/downloads/$file_name"

echo "$final_url"

echo "Downloading Paper version $latest_version, build $latest_build..."
curl -o paper.jar "$final_url"


java -jar paper.jar


if [ "$eula" = "true" ]; then
    rm -f eula.txt
    echo "eula=true" > eula.txt
fi

java -jar paper.jar
