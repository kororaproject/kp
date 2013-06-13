#!/bin/bash
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
  mkdir -p tmp-${DATE}/$x
  cd tmp-${DATE}/$x
  yumdownloader --source --disablerepo=korora $x >/dev/null 2>&1
  f_version=$(ls ${x}* |awk -F "${x}-" '{print $2}' |awk -F ".fc" '{print $1}')
  rm -f *
  yumdownloader --source --enablerepo=updates-testing --disablerepo=korora $x >/dev/null 2>&1
  f_version_testing=$(ls ${x}* |awk -F "${x}-" '{print $2}' |awk -F ".fc" '{print $1}')
  cd -
  echo "Korora Version = ${k_version}-${k_release}"
  echo -e "Fedora Version = $f_version"
  echo -e "Fedora Version (testing) = $f_version_testing\n"
done
rm -Rf tmp-${DATE}
