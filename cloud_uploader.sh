#!/bin/bash

GREEN="\033[0;32m"
RED="\033[31m"
DEFAULT="\033[0m"

function authenticate() {
    az login --use-device-code
}

function create_resource_group() {
    echo "Let's create a resource group first!"
    read -p "Enter name of resource group: " resource_group
    read -p "Enter location: " location
    az group create \
        --name $resource_group \
        --location $location

    if [ $? -eq 0 ]; then
        echo -e "${GREEN} Resource group created ${DEFAULT}"
    else
        echo -e "${RED} Failed to create resource group ${DEFAULT}"
    fi
}

function create_storage_account() {
    echo "Let's create a storage account next!"
    read -p "Enter storage account name: " storage_account
    read -p "Enter resource group name: " resource_group
    read -p "Enter location: " location
    az storage account create \
        --name $storage_account \
        --resource-group $resource_group \
        --location $location \
        --sku Standard_LRS
    if [ $? -eq 0 ]; then
        echo -e "${GREEN} Storage account created ${DEFAULT}"
    else
        echo -e "${RED} Storage account creation failed ${DEFAULT}"
    fi
}

function create_container() {
    echo "Let's create a container next!"
    read -p "Enter container name: " container
    read -p "Enter storage account name: " storage_account
    az storage container create \
        --name $container \
        --account-name $storage_account

    if [ $? -eq 0 ]; then
        echo -e "${GREEN} Container created ${DEFAULT}"
    else
        echo -e "${RED} Container creation failed ${DEFAULT}"
    fi
}

function upload() {
    echo "upload your file!"
    read -p "Enter account name: " account_name
    read -p "Enter container name: " container_name
    read -p "Enter name of file as it would be stored in azure blob: " file_name
    read -p "Enter path to the file as stored in your pc: " path_to_file

    az storage blob upload \
        --account-name $account_name \
        --container-name $container_name \
        --name $file_name \
        --file $path_to_file \
        --auth-mode login
    if [ $? -eq 0 ]; then
        echo -e "${GREEN} upload successful ${DEFAULT}"
    else
        echo -e "${RED} upload failed ${DEFAULT}"
    fi
}

upload
