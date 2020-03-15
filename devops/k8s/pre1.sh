#!/bin/bash

## ubuntu update
sudo apt update -y
sudo apt upgrade -y

## kubectl setup
curl -o kubectl curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
kubectl version --short --client

## aws iam authentication setup
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
aws-iam-authenticator help

## eksctl setup
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.4.5 sh -
cd istio-1.4.5
echo 'export PATH=$PWD/bin:$PATH' >> ~/.bashrc
cd

## aws cli setup
sudo apt -y install python-pip && sudo pip install --upgrade pip && sudo pip install awscli --upgrade

##### Configure AWS Profile
aws configure
