#!/bin/bash

image_domain=[!/]*/
image_project=[!/]*/
image_repository=[!/]*:
image_tag=[!:]*

while getopts ":d:p:r:t:" opt; do
  case $opt in
    d)
      echo "-d was triggered, Parameter: $OPTARG" >&2
      image_domain=[!/]*$OPTARG[!/]*/
      ;;
    p)
      echo "-p was triggered, Parameter: $OPTARG" >&2
      image_project=[!/]*$OPTARG[!/]*/
      ;;
    r)
      echo "-r was triggered, Parameter: $OPTARG" >&2
      image_repository=[!/]*$OPTARG[!/]*:
      ;;
    t)
      echo "-t was triggered, Parameter: $OPTARG" >&2
      image_tag=.*$OPTARG.*
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

filter="^(${image_domain})(${image_project})(${image_repository})(${image_tag})$"
echo ${filter}

local_images=`docker images --format '{{ .Repository }}:{{ .Tag }}'`
for local_image in $local_images
do
	if [[ $local_image =~ $filter ]]; then
		echo $local_image
    echo ${#BASH_REMATCH[@]}
    echo ${BASH_REMATCH[1]}
    echo ${BASH_REMATCH[2]}
    echo ${BASH_REMATCH[3]}
    echo ${BASH_REMATCH[4]}
	fi
done
