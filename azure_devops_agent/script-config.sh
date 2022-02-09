#!/usr/bin/env bash

# install zip unzip

apt-get -y update
apt-get -y install zip unzip

# install az cli from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt#option-2-step-by-step-installation-instructions

apt-get -y update
apt-get -y install ca-certificates curl apt-transport-https lsb-release gnupg

curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    tee /etc/apt/sources.list.d/azure-cli.list

apt-get -y update
apt-get -y install azure-cli

# install python package index (pip)

apt-get -y install python-pip

# install docker from https://docs.docker.com/engine/install/ubuntu/

curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
    gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io

# install kubectl from https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management

curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

apt-get -y update
apt-get -y install kubectl

# install helm from https://helm.sh/docs/intro/install/#from-apt-debianubuntu

curl https://baltocdn.com/helm/signing.asc | apt-key add -

echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list

apt-get -y update
apt-get -y install helm
