#!/usr/bin/env bash

executable=$(jq .scripts.start package.json)
if [ "$executable" = "null" ];then
	echo no start script
	executable=$(jq .main package.json)
	if [ "$executable" != "null" ];then
		echo $executable executable_js
		return $executable
	else
		echo no main
		if [ -e index.js ];then
			executable=index.js
			echo index.js found $executable
			return $executable
		else
			echo no index.js found
			if [ -e app.js ];then
				executable=app.js
				echo app.js found $executable
				return $executable
			else
				echo no app.js found
				if [ -e server.js ];then
					executable=server.js
					echo server.js found $executable
					return $executable
				else
					echo no entrypoint found
				fi
			fi
		fi

	fi
else
	echo start script $executable
	return $executable
fi