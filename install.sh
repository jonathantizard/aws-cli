#!/bin/bash

echo "Set AWS credentials and config"
read -p 'ACCESS_KEY_ID: ' ACCESS_KEY_ID
read -sp 'SECRET_ACCESS_KEY: ' SECRECT_ACCESS_KEY
echo ""
read -p 'REGION: ' REGION
read -p 'OUTPUT: ' OUTPUT

echo "Building Image"

docker build \
       -t aws-cli \
       --build-arg ACCESS_KEY_ID=${ACCESS_KEY_ID} \
       --build-arg SECRET_ACCESS_KEY=${SECRECT_ACCESS_KEY} \
       --build-arg REGION=${REGION} \
       --build-arg OUTPUT=${OUTPUT} \
       --no-cache .

echo "Adding Alias"

PROFILE="${HOME}/.bash_profile"
RC="${HOME}/.bashrc"
ZSHRC="${HOME}/.zshrc"

RCAWSALIAS='alias aws='\''docker run --rm -it -v "$(pwd):/project" aws-cli $(echo "aws " && tty &>/dev/null)'\'''
RCEBALIAS='alias eb='\''docker run --rm -it -v "$(pwd):/project" aws-cli $(echo "eb " && tty &>/dev/null)'\'''
PROFILEALIAS="[[ -r ~/.bashrc ]] && . ~/.bashrc"
ZSHALIAS="bash -l"

echo "[AWS Alias]"

if grep -qF "${RCAWSALIAS}" ${RC}; then
    echo "Skipping AWS alias - may already exist"
else
    echo ${RCAWSALIAS} >> ${RC} && echo "Added AWS alias tp bashrc"
fi

echo "[EB Alias]"

if grep -qF "${RCEBALIAS}" ${RC}; then
    echo "Skipping EB Alias - may already exist"
else
    echo ${RCEBALIAS} >> ${RC} && echo "Added EB alias to bashrc"
fi

echo "[MAC Profile]"

#Setup Bash Profile MAC
if [[ -f $PROFILE ]] && ! grep -qF "${PROFILEALIAS}" ${PROFILE}; then
    echo ${PROFILEALIAS} > ${PROFILE} \
    && echo "Created a .bash_profile and inherited .bashrc"
else
    echo "Skipping MAC profile - none existant or already added"
fi

echo "[ZSH]"

#Setup ZSH ALL if exist
if [[ -f ${ZSHRC} ]] && ! grep -qF "${ZSHALIAS}" ${ZSHRC}; then
    echo ${ZSHALIAS} >> ${ZSHRC} \
    && echo "Added inherit bash path to .zshrc"
else
    echo "Skipping ZSH - none existant or already added"
fi

echo "[COMPLETED]"