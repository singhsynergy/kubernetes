#!/bin/bash

echo "========== Step1: update and upgrade the packages🔗 =========="
sudo apt update
sudo apt -y full-upgrade
sleep 5
echo -e ""

echo "========== Step2: disable swap space🔗 =========="
sudo sudo swapoff -a
sleep 5
echo -e ""


echo "========== Step3: Install kubelet kubectl kubeadm 🔗 =========="
until [ "$list" = "0" ]
do
read -r -p "Press [yY] if you want to select any specific kubernetes version and [nN] for the latest Version:  " list
case $list in
        [yY])
		curl -s https://api.github.com/repos/kubernetes/kubernetes/releases | grep '"tag_name":' | awk -F'"' '{print $4}' | grep -v -E 'rc|beta|alpha' |  sort -Vr
		read -r -p "Enter the Kubernetes version that you want to install example 1.22.0-00: " K8SVERSION
		
		echo -e "\n========== Installing kubelet kubectl kubeadm 🔗 =========="
		curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
		echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
		sudo apt-get update
		sudo apt-get install -y kubelet=$K8SVERSION kubectl=$K8SVERSION kubeadm=$K8SVERSION
		sudo apt-mark hold kubelet kubeadm kubectl
		echo "========== Installation done successfully 🔗 =========="
		sleep 5
		sh containerd.sh
		exit 1;;
        [nN])
                echo -e "\n========== Installing kubelet kubectl kubeadm 🔗 =========="
		sudo apt -y install curl apt-transport-https
		curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
		echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
		sudo apt-get update
		sudo apt-get install -y kubelet kubectl kubeadm
		sudo apt-mark hold kubelet kubeadm kubectl
		echo "========== kubelet kubectl kubeadm installed successfully 🔗 =========="
		sleep 5
		sh containerd.sh
                exit 1;;
        *)
                echo "You have entered wrong option"
                ;;
esac
done
