#!/bin/bash

# Create a dockerfile for our user
# Note: Environment variables aren't available in a docker build command
#   so we need to create a Dockerfile with them already set
# Note: You must be root to use docker under Fedora and CentOS[1]
#   hence we will run the docker commands with sudo
# [1] http://www.projectatomic.io/blog/2015/08/why-we-dont-let-non-root-users-run-docker-in-centos-fedora-or-rhel/

if [[ "${EUID}" -eq 0 ]]; then
  echo "Please run this script as non-root, we will use sudo for docker commands."
  exit 1
fi

if [[ "${1}" =~ build ]]; then
  Dockerfile=$(cat << EOF
FROM fedora:latest

RUN dnf --refresh upgrade -y
RUN dnf install -y createrepo git openssh-clients mock rpm-sign rsync spectool transifex-client

RUN groupadd -g ${GROUPS} ${USER} && useradd -m -u ${UID} -g ${GROUPS} -G mock ${USER}

USER ${USER}
ENV HOME /home/${USER}
RUN /bin/bash
EOF
)
  echo sudo docker build -t korora/kp - <<< "${Dockerfile}"
  sudo docker build -t korora/kp - <<< "${Dockerfile}"
elif [[ "${1}" =~ root ]]; then
  sudo docker run --cap-add=sys_admin --net=host --rm=false --user=root -w /root -v /tmp/rpmbuild:/rpmbuild -i -t korora/kp /bin/bash
else
  echo sudo docker run --cap-add=sys_admin --net=host --rm=false --user="${USER}" -w /home/"${USER}" -v /home/"${USER}"/:/home/"${USER}" -v /tmp/rpmbuild:/rpmbuild -i -t korora/kp /bin/bash
  sudo docker run --cap-add=sys_admin --net=host --rm=false --user="${USER}" -w /home/"${USER}" -v /home/"${USER}"/:/home/"${USER}" -v /tmp/rpmbuild:/rpmbuild -i -t korora/kp /bin/bash
fi


