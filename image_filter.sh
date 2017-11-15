#!/bin/bash

image_domain=[^/]*
image_project=[^/]*
image_repository=.*
image_tag=.*

new_domain=""
new_project=""
new_repository=""
new_tag=""

operation=""

while getopts ":d:p:r:t:x:y:z:w:o:" opt; do
  case $opt in
    d)
      echo "-d was triggered, Parameter: $OPTARG" >&2
      image_domain=[^/]*$OPTARG[^/]*
      ;;
    p)
      echo "-p was triggered, Parameter: $OPTARG" >&2
      image_project=[^/]*$OPTARG[^/]*
      ;;
    r)
      echo "-r was triggered, Parameter: $OPTARG" >&2
      image_repository=.*$OPTARG.*
      ;;
    t)
      echo "-t was triggered, Parameter: $OPTARG" >&2
      image_tag=.*$OPTARG.*
      ;;
    x)
      echo "-x was triggered, Parameter: $OPTARG" >&2
      new_domain=$OPTARG
      ;;
    y)
      echo "-y was triggered, Parameter: $OPTARG" >&2
      new_project=$OPTARG
      ;;
    z)
      echo "-z was triggered, Parameter: $OPTARG" >&2
      new_repository=$OPTARG
      ;;
    w)
      echo "-w was triggered, Parameter: $OPTARG" >&2
      new_tag=$OPTARG
      ;;
    o)
      echo "-o was triggered, Parameter: $OPTARG" >&2
      operation=$OPTARG
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

filter="^(${image_domain})/(${image_project})/(${image_repository}):(${image_tag})$"
echo ${filter}

local_images=`docker images --format '{{ .Repository }}:{{ .Tag }}'`
for local_image in $local_images
do
  if [[ $local_image =~ $filter ]]; then
    this_domain=""
    this_project=""
    this_repository=""
    this_tag=""

    echo $local_image
    # echo ${#BASH_REMATCH[@]}
    # echo ${BASH_REMATCH[1]}
    # echo ${BASH_REMATCH[2]}
    # echo ${BASH_REMATCH[3]}
    # echo ${BASH_REMATCH[4]}
    if [ -z "${new_domain}" ]; then
      this_domain=${BASH_REMATCH[1]}
    else
      this_domain=${new_domain}
    fi

    if [ -z "${new_project}" ]; then
      this_project=${BASH_REMATCH[2]}
    else
      this_project=${new_project}
    fi

    if [ -z "${new_repository}" ]; then
      this_repository=${BASH_REMATCH[3]}
    else
      this_repository=${new_repository}
    fi

    if [ -z "${new_tag}" ]; then
      this_tag=${BASH_REMATCH[4]}
    else
      this_tag=${new_tag}
    fi

    image=${BASH_REMATCH[1]}/${BASH_REMATCH[2]}/${BASH_REMATCH[3]}:${BASH_REMATCH[4]}
    new_image=${this_domain}/${this_project}/${this_repository}:${this_tag}

    if [ -z "${operation}" ]; then
      echo "${image} | ${new_image}" 
    elif [ "${operation}" = "pull" ]; then
      echo docker pull ${new_image} >> filter_pull.sh
    elif [ "${operation}" = "push" ]; then
      echo docker push ${image} >> filter_push.sh
    elif [ "${operation}" = "tag" ]; then
      echo docker tag ${image} ${new_image} >> filter_tag.sh
    elif [ "${operation}" = "rmi" ]; then
      echo docker rmi ${image} >> filter_rmi.sh
    fi
  fi
done
