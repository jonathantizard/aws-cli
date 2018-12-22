#!/bin/bash

echo "====Set AWS credentials and config===="
read -p 'ACCESS_KEY_ID: ' ACCESS_KEY_ID
read -sp 'SECRET_ACCESS_KEY: ' SECRECT_ACCESS_KEY
echo ""
read -p 'REGION: ' REGION
read -p 'OUTPUT: ' OUTPUT

echo "====Cleaning images===="
docker system prune -af

echo "====Building Image===="

 if docker build \
       -t aws-cli \
       --build-arg ACCESS_KEY_ID=${ACCESS_KEY_ID} \
       --build-arg SECRET_ACCESS_KEY=${SECRECT_ACCESS_KEY} \
       --build-arg REGION=${REGION} \
       --build-arg OUTPUT=${OUTPUT} \
       --no-cache . ; then

    echo  "====Docker image build successfully===="

else

    echo "====Docker image failed to build.. exiting===="
    exit

fi

PROFILE="${HOME}/.bash_profile"
RC="${HOME}/.bashrc"
ZSHRC="${HOME}/.zshrc"

AWSALIAS='alias aws='\''docker run --rm -it -v "$(pwd):/project" aws-cli $(echo "aws " && tty &>/dev/null)'\'''
EBALIAS='alias eb='\''docker run --rm -it -v "$(pwd):/project" aws-cli $(echo "eb " && tty &>/dev/null)'\'''
SAMALIAS='alias sam='\''docker run --rm -it -v "$(pwd):/project" aws-cli $(echo "sam " && tty &>/dev/null)'\'''
PROFILEALIAS="[[ -r ~/.bashrc ]] && . ~/.bashrc"

function add_alias {

    local aliasName=$1
    local alias=$2
    local aliasFile=$3

    echo -e "[Adding ${aliasName} Alias at ${aliasFile}]"

    if [ ! -f "${aliasFile}" ] || grep -qF "${alias}" ${aliasFile}; then
        echo -e "-- Skipping ${aliasName} - may already exist \n"
    else
        echo -e ${alias} >> ${aliasFile} && echo "++ Added ${aliasName} alias \n"
    fi

}

echo -e "====Adding Alias's==== \n"

add_alias "RC AWS" "${AWSALIAS}" $RC

add_alias "RC EB" "${EBALIAS}" $RC

add_alias "RC SAM" "${SAMALIAS}" $RC

add_alias "ZSH AWS" "${AWSALIAS}" $ZSHRC

add_alias "ZSH EB" "${EBALIAS}" $ZSHRC

add_alias "ZSH SAM" "${SAMALIAS}" $ZSHRC

add_alias "PROFILE" "${PROFILEALIAS}" $PROFILE

exec $SHELL
echo "====[RESTARTING SHELL...COMPLETED]===="
