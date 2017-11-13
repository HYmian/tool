#! /bin/bash

harbor_endpoint=harbor
harbor_username=admin
harbor_password=Harbor12345
harbor_schema=https

format() {
  echo $1 | tr -d '"'
}

projects=`curl -ksS -u ${harbor_username}:${harbor_password} ${harbor_schema}://${harbor_endpoint}/api/projects`
project_num=`echo ${projects} | jq ". | length"`

echo $projects
echo -e "#! /bin/bash\n" > pull_$harbor_endpoint.sh
echo -e "#! /bin/bash\n" > push_$harbor_endpoint.sh

for ((i=0; i<${project_num}; ++i))
do
  project=`echo ${projects} | jq ".[$i]"`
  echo $project
  project_id=`echo ${project} | jq '. | getpath(["project_id"])'`
  project_name=`echo ${project} | jq '. | getpath(["name"])'`
  project_public=`echo ${project} | jq '. | getpath(["public"])'`

  echo curl -k -X POST -u ${harbor_username}:${harbor_password} ${harbor_schema}://${harbor_endpoint}/api/projects \
    -H \'accept: application/json\' \
    -H \'Content-Type: text/plain\' \
    -d \'{ \
      \"project_name\": ${project_name}, \
      \"public\": ${project_public} \
    }\' >> push_${harbor_endpoint}.sh

  repositories=`curl -ksS -u ${harbor_username}:${harbor_password} ${harbor_schema}://${harbor_endpoint}/api/repositories?project_id=${project_id} | jq '.[] | getpath(["name"])'`
  echo ${repositories}
  for repository in ${repositories}
  do
    echo $repository
    repository=`format $repository`
    tags=`curl -ksS -u ${harbor_username}:${harbor_password} ${harbor_schema}://${harbor_endpoint}/api/repositories/${repository}/tags | jq '.[] | getpath(["name"])'`
    echo ${tags}
    for tag in ${tags}
    do
      tag=`format $tag`
      echo docker pull ${harbor_endpoint}/${repository}:${tag} >> pull_${harbor_endpoint}.sh
      echo docker push ${harbor_endpoint}/${repository}:${tag} >> push_${harbor_endpoint}.sh
    done
  done
done
