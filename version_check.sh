#!/bin/bash
echo -e "Checking for versions in stable..."
for x in anaconda firstboot kde-settings korora-backgrounds korora-release preupgrade shared-mime-info ; do k_version=$(grep ^KP_VERSION conf/packages.d/kp-${x}.conf |awk -F "=" {'print $2'}) ; if [ $x == "korora-backgrounds" ]; then x="spherical-cow-backgrounds" ; elif [ $x == korora-release ] ; then x="generic-release"; fi ; echo $x ; f_version=$(yum info $x |grep ^Version |awk {'print $3'}) ; echo "$x" ; echo $k_version ; echo -e "$f_version \n" ; done

echo -e "Checking for versions in testing..."
for x in anaconda firstboot kde-settings korora-backgrounds korora-release preupgrade shared-mime-info ; do k_version=$(grep ^KP_VERSION conf/packages.d/kp-${x}.conf |awk -F "=" {'print $2'}) ; if [ $x == "korora-backgrounds" ]; then x="spherical-cow-backgrounds" ; elif [ $x == korora-release ] ; then x="generic-release"; fi ; echo $x ; f_version=$(yum info --enablerepo=updates-testing $x |grep ^Version |awk {'print $3'}) ; echo "$x" ; echo $k_version ; echo -e "$f_version \n" ; done
