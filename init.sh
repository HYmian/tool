#! /bin/bash

# config system
echo "disable selinux"
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# add repo

# kubectl
echo "add kubernetes repo"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF
# vs code
echo "add vs code repo"
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
# rpm fusion
echo "fusion repo"
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "makecache"
dnf makecache -y

# install common tools
dnf install -y \
	kde-l10n-zh_CN \
	vim \
	git \
	docker \
	kubectl \
	steam \
	vlc \
	libreoffice \
	code \
	steam

# install devlop tools
dnf install -y \
	golang golang-docs \
	java-1.8.0-openjdk-devel

# chrome
echo "install chrome"
dnf install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

# install oh-my-zsh
echo "install oh-my-zsh"
dnf install zsh -y && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
