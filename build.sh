#!/bin/bash

ignore_errors=0
build_platform=alpine3.8
asset_version=${TRAVIS_TAG:-local-build}
asset_filename=sensu-plugins-check_nwc_health_${asset_version}.tar.gz
asset_image=sensu-plugins-check_nwc_health-${build_platform}:${asset_version}

if [ "${asset_version}" = "local-build" ]; then
  echo "Local build"
  ignore_errors=1
fi

test -d ${PWD}/dist || mkdir ${PWD}/dist
echo "Check for asset file: ${asset_filename}"
if [ -f "$PWD/dist/${asset_filename}" ]; then
  echo "File: "$PWD/dist/${asset_filename}" already exists!!!"
  [ $ignore_errors -eq 0 ] && exit 1  
else
  echo "Check for docker image: ${asset_image}"
  if [[ "$(docker images -q ${asset_image} 2> /dev/null)" == "" ]]; then
    echo "Docker image not found...we can build"
    echo "Building Docker Image: sensu-plugins-check_nwc_health-${build_platform}"
    docker build --build-arg "ASSET_VERSION=$asset_version" -t ${asset_image} -f Dockerfile .

    echo "Making Asset: /assets/${asset_filename}"
    docker run --rm -v "$PWD/dist:/dist" ${asset_image} cp /assets/${asset_filename} /dist/
    docker rmi $(docker images -q ${asset_image} 2> /dev/null)
  else
    echo "Image already exists!!!"
    [ $ignore_errors -eq 0 ] && exit 1  
  fi
fi

