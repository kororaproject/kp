#!/bin/bash

if [ "$1" == "--keep" ]
then
  KEEP=true
fi

DATE="$(date +%s)"
echo -e "Checking for versions..."
for x in anaconda firstboot kde-settings korora-backgrounds korora-release shared-mime-info
do
  k_version=$(grep ^KP_VERSION= ~/kpbuild/conf/packages.d/kp-${x}.conf |awk -F "=" {'print $2'})
  k_release=$(grep ^KP_RELEASE= ~/kpbuild/conf/packages.d/kp-${x}.conf |awk -F "=" {'print $2'})
  if [ $x == "korora-backgrounds" ]
  then
    x="spherical-cow-backgrounds"
  elif [ $x == korora-release ]
  then x="generic-release"
  fi
  echo $x
  mkdir -p tmp-${DATE}/$x/{stable,testing}
  cd tmp-${DATE}/$x/stable
  yumdownloader --source --disablerepo=korora $x >/dev/null 2>&1
  f_version=$(ls ${x}* |awk -F "${x}-" '{print $2}' |awk -F ".fc" '{print $1}')
  cd - >/dev/null 2&>1
  cd tmp-${DATE}/$x/testing
  yumdownloader --source --enablerepo=updates-testing --disablerepo=korora $x >/dev/null 2>&1
  f_version_testing=$(ls ${x}* |awk -F "${x}-" '{print $2}' |awk -F ".fc" '{print $1}')
  cd - >/dev/null 2&>1
  echo "${k_version}-${k_release} - Korora Version"
  echo -e "$f_version - Fedora Version (stable)"
  echo -e "$f_version_testing - Fedora Version (testing)\n"
done
if [ ${KEEP} ]
then
  echo "Files kept at tmp-${DATE}/"
else
  rm -Rf tmp-${DATE}
fi
