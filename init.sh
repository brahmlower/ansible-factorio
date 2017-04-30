#!/usr/bin/env bash

VERSIONS=(0.15.5 0.14.23 0.13.20 0.12.35)

mkdir -p vendor
for VERSION in "${VERSIONS[@]}"
do
	mkdir -p vendor/mock.factorio.com/get-download/$VERSION/headless/;
	if [ ! -f vendor/mock.factorio.com/get-download/$VERSION/headless/linux64 ];
  then
		echo "Downloading headless server $VERSION";
		wget --quiet --show-progress www.factorio.com/get-download/$VERSION/headless/linux64 -O vendor/mock.factorio.com/get-download/$VERSION/headless/linux64;
  else
    echo "Already have headless server $VERSION"
	fi;
done
