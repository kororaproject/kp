# Kickstart file for Korora Remix (GNOME) x86_64
# To use this for 32bit build, :4,$s/x86_64/i386/g
# and build with 'setarch i686 livecd-creator ...'

#
# KP:DESCRIPTION:START
#
# var KP_RELEASE_META_LABEL=gnome
#
#
# KP:DESCRIPTION:END
#



%include %%KP_KICKSTART_DIR%%/fedora-live-base.ks

#version=DEVEL
install

#install system from the net, to get latest updates
#url --url=ftp://mirror.internode.on.net/pub/fedora/linux/releases/%%KP_VERSION%%/Fedora/x86_64/os/
url --url=ftp://mirror.internode.on.net/pub/fedora/linux/development/%%KP_VERSION%%/%%KP_BASEARCH%%/os/

lang en_AU.UTF-8
keyboard us
#network --onboot yes --device eth0 --bootproto dhcp --noipv6
timezone --utc Australia/Sydney
#rootpw  --iscrypted $6$D8V.j2ICJUxPjPEl$S.OjfjUxpIBfYKEMjSBolPPHGG1wLSIrihg75qvd1K34CUA7KfPC3fIzypVY/A4LSPs8uwG3joDXMiZ6vGaN40
selinux --enforcing
authconfig --enableshadow --passalgo=sha512 --enablefingerprint
firewall --enabled --service=ssh,mdns,ipp-client,samba-client
xconfig --startxonboot
services --enabled=NetworkManager,lirc --disabled=abrtd,abrt-ccpp,abrt-oops,abrt-vmcore,capi,iscsi,iscsid,isdn,netfs,network,nfs,nfslock,pcscd,rpcbind,rpcgssd,rpcidmapd,rpcsvcgssd,sendmail,sshd

#Partitioning, for Live CD
part / --size 7188 --fstype ext4


#Partitioning, for virtual machine testing
#clearpart --all --drives=sda
#
#part /boot --fstype=ext4 --size=512
#part pv.EaGFJm-w7pp-JMFF-02sd-ynAj-3bbx-Yj8Kfz --grow --size=512
#
#volgroup system --pesize=32768 pv.EaGFJm-w7pp-JMFF-02sd-ynAj-3bbx-Yj8Kfz
#logvol / --fstype=ext4 --name=root --vgname=system --grow --size=1024 --maxsize=20480
#logvol swap --name=swap --vgname=system --grow --size=1024 --maxsize=2048
#bootloader --location=mbr --driveorder=sda --append="rhgb quiet"

#
# REPOS
#

repo --name="Adobe Systems Incorporated" --baseurl=http://linuxdownload.adobe.com/linux/%%KP_BASEARCH%%/ --cost=1000

repo --name="Fedora %%KP_VERSION%% - %%KP_BASEARCH%%" --baseurl=ftp://mirror.internode.on.net/pub/fedora/linux/development/%%KP_VERSION%%/%%KP_BASEARCH%%/os/ --cost=1000
#repo --name="Fedora %%KP_VERSION%% - %%KP_BASEARCH%% - Updates" --baseurl=ftp://mirror.internode.on.net/pub/fedora/linux/updates/%%KP_VERSION%%/%%KP_BASEARCH%%/ --cost=1000
repo --name="Fedora %%KP_VERSION%% - %%KP_BASEARCH%% - Updates" --baseurl=http://download.fedoraproject.org/pub/fedora/linux/updates/%%KP_VERSION%%/%%KP_BASEARCH%%/ --cost=1000
repo --name="Google Chrome" --baseurl=http://dl.google.com/linux/chrome/rpm/stable/%%KP_BASEARCH%%/ --cost=1000
repo --name="Korora %%KP_VERSION%%" --baseurl=file://%%KP_REPOSITORY_DIR%%/%%KP_VERSION%%/%%KP_BASEARCH%%/ --cost=10

#repo --name="Kororaa Testing" --baseurl=file:///home/chris/repos/kororaa/testing/%%KP_VERSION%%/%%KP_BASEARCH%%/ --cost=5
#repo --name="Ksplice Uptrack for Fedora" --baseurl=http://www.ksplice.com/yum/uptrack/fedora/%%KP_VERSION%%/%%KP_BASEARCH%%/ --cost=1000

repo --name="RPMFusion Free" --baseurl=http://download1.rpmfusion.org/free/fedora/development/%%KP_VERSION%%/%%KP_BASEARCH%%/os/ --cost=1000
#repo --name="RPMFusion Free" --baseurl=http://download1.rpmfusion.org/free/fedora/releases/%%KP_VERSION%%/Everything/%%KP_BASEARCH%%/os/ --cost=1000
#repo --name="RPMFusion Free - Updates" --baseurl=http://download1.rpmfusion.org/free/fedora/updates/%%KP_VERSION%%/%%KP_BASEARCH%%/ --cost=1000

repo --name="RPMFusion Non-Free" --baseurl=http://download1.rpmfusion.org/nonfree/fedora/development/%%KP_VERSION%%/%%KP_BASEARCH%%/os/ --cost=1000
#repo --name="RPMFusion Non-Free" --baseurl=http://download1.rpmfusion.org/nonfree/fedora/releases/%%KP_VERSION%%/Everything/%%KP_BASEARCH%%/os/ --cost=1000
#repo --name="RPMFusion Non-Free - Updates" --baseurl=http://download1.rpmfusion.org/nonfree/fedora/updates/%%KP_VERSION%%/%%KP_BASEARCH%%/ --cost=1000
repo --name="VirtualBox" --baseurl=http://download.virtualbox.org/virtualbox/rpm/fedora/%%KP_VERSION%%/%%KP_BASEARCH%%/ --cost=1000

#
# PACKAGES
#

%packages
@admin-tools
@critical-path-base
@base-x
@british-support
@core
@dial-up
@fonts
@hardware-support
selinux-policy
selinux-policy-targeted
@gnome-desktop
@gnome-games
@online-docs
@printing
@input-methods
-ibus-pinyin-db-open-phrase
ibus-pinyin-db-android
#@office

#Needed apparently
kernel
kernel-modules-extra
memtest86+

# grub-efi and grub2 and efibootmgr so anaconda can use the right one on install.
grub-efi
grub2
efibootmgr

# FIXME; apparently the glibc maintainers dislike this, but it got put into the
# desktop image at some point.  We won't touch this one for now.
nss-mdns

#Install 3rd party repo releases
adobe-release
google-chrome-release
#ksplice-uptrack
rpmfusion-free-release
rpmfusion-nonfree-release
virtualbox-release

# (RE)BRANDING
-fedora-logos
-fedora-release
-fedora-release-notes
korora-extras
korora-release
korora-logos
korora-release-notes

elementary-gtk
elementary-icon-theme

#Package for checksumming livecd on boot, installer, memtest
anaconda
anaconda-widgets
isomd5sum

#
# EXTRA PACKAGES
#add-remove-extras
akmods
alacarte
argyllcms
bash-completion
beesu
#bootconf-gui
brltty
btrfs-progs
chrony
cinnamon
control-center
cups-pdf
dconf-editor
eekboard
ekiga
empathy
evince
evolution
evolution-mapi
expect
firefox
*firmware*
font-manager
fpaste
fprintd-pam
fuse
libXft-infinality
freetype-infinality
fontconfig-infinality
gconf-editor
gimp
git
gnome-disk-utility
gnome-games*
gnome-lirc-properties
#gnome-packagekit-extra
gnome-packagekit
#gnome-shell
#gnome-shell-extension-*
#gnome-shell-extensions-mgse-*
-gnome-shell-extension-gpaste
-gnome-shell-extension-pidgin
#gnome-shell-extension-apps-menu
#gnome-shell-extension-auto-move-windows
gnome-shell-extension-user-theme
#gnome-shell-extension-theme-selector
gnome-shell-extension-workspacesmenu
gnome-shell-extension-alternative-status-menu
gnome-shell-extension-dock
gnome-shell-extension-drive-menu
gnome-shell-extension-places-menu
-gnome-shell-extension-native-window-placement
gnome-shell-extension-presentation-mode
gnome-shell-extension-xrandr-indicator
gnome-shell-theme-*
gnome-system-log
gnome-tweak-tool
gnote
#gloobus-preview

gparted
gpgme
gtk-murrine-engine
gtk-unico-engine
gvfs-obexftp
gwibber
hardlink
htop
inkscape
iok
jack-audio-connection-kit
java-1.7.0-openjdk
#java-1.7.0-openjdk-plugin
jockey
jockey-gtk
jockey-selinux
korora-settings-gnome
libreoffice-calc
libreoffice-draw
libreoffice-emailmerge
libreoffice-graphicfilter
libreoffice-impress
libreoffice-langpack-en
libreoffice-math
libreoffice-ogltrans
libreoffice-opensymbol-fonts
libreoffice-pdfimport
libreoffice-presenter-screen
libreoffice-report-builder
libreoffice-ure
libreoffice-writer
libreoffice-xsltfilter
libimobiledevice
libsane-hpaio
lirc
lirc-remotes
liveusb-creator
mtpfs
mlocate
mozilla-adblock-plus
mozilla-downthemall
mozilla-flashblock
mozilla-xclear
mtools
nautilus-actions
nautilus-extensions
nautilus-image-converter
nautilus-open-terminal
#nautilus-pastebin
#nautilus-search-tool
nautilus-sendto
ncftp
#NetworkManager-gnome
NetworkManager-openconnect
NetworkManager-openswan
NetworkManager-openvpn
NetworkManager-pptp
NetworkManager-vpnc
NetworkManager-wimax
-ntp
p7zip
p7zip-plugins
PackageKit-command-not-found
PackageKit-gtk3-module
pcsc-lite
pcsc-lite-ccid
#pidgin
#pidgin-rhythmbox
planner
polkit-desktop-policy
prelink
pybluez
samba
samba-winbind
sane-backends
screen
shotwell
simple-scan
-smartmontools
#synaptic
system-config-lvm
system-config-printer
#tilda
-transmission-gtk
deluge
vim
#vinagre
#vino
#wammu
wget
xfsprogs
yumex
#yum-plugin-fastestmirror
yum-plugin-priorities
yum-plugin-security
yum-updatesd

#
# MULTIMEDIA
alsa-plugins-pulseaudio
alsa-utils
audacity-freeworld
brasero
brasero-nautilus
faac
fbreader-gtk
ffmpeg
flac
frei0r-plugins
#gecko-mediaplayer
deja-dup
-gnome-mplayer
-mplayer
-mencoder
-gnome-mplayer-nautilus
gstreamer-ffmpeg
gstreamer-plugins-bad
gstreamer-plugins-bad-free
gstreamer-plugins-bad-free-extras
gstreamer-plugins-bad-nonfree
gstreamer-plugins-good
gstreamer-plugins-ugly
HandBrake-gui
lame
libdvdcss
libdvdnav
libdvdread
libmatroska
libmpg123
#me-tv (this pulls in xine-ui)
#mencoder
#Miro
#mozilla-vlc
mpg321
nautilus-sound-converter
openshot
PackageKit-browser-plugin
PackageKit-gstreamer-plugin
pavucontrol
#pitivi
policycoreutils-gui
pulseaudio-module-bluetooth
rawtherapee
rhythmbox
soundconverter
sound-juicer
transcode
vlc
vlc-extras
vorbis-tools
x264
xine-lib-extras
xine-lib-extras-freeworld
xine-plugin
xorg-x11-apps
xscreensaver-gl-extras
xscreensaver-extras
xscreensaver-base
xorg-x11-resutils
xvidcore

#Flash deps - new meta-rpm should take care of these
#pulseaudio-libs.i686
#alsa-plugins-pulseaudio.i686
#libcurl.i686
#nspluginwrapper.i686

#
#Development tools for out of tree modules
gcc
kernel-devel
dkms
time

#Out of kernel GPL drivers
#akmod-rt2860
#akmod-rt2870
#akmod-rt3070
#akmod-VirtualBox-OSE
#akmod-wl (I don't think this is GPLv2!)
#kmod-staging
#mesa-dri-drivers-experimental

%end

#%post --nochroot
#umount $INSTALL_ROOT/var/cache/yum
#%end

%post

echo -e "\n*****\nPOST SECTION\n*****\n"

#Set resolv.conf
echo "nameserver 192.168.28.1" >> /etc/resolv.conf

#Build out of kernel modules (so it's not done on first boot)
echo "****BUILDING AKMODS****"
/usr/sbin/akmods --force

#Import keys
for x in fedora google-chrome virtualbox korora adobe rpmfusion-free-fedora-17-primary rpmfusion-nonfree-fedora-17-primary rpmfusion-free-fedora-18-primary rpmfusion-nonfree-fedora-18-primary ; do rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-$x ; done

#Start yum-updatesd
systemctl enable yum-updatesd.service

#Update locate database
/usr/bin/updatedb

#Rebuild initrd to remove Generic branding (necessary?)
#/sbin/dracut -f

#Let's run prelink
/usr/sbin/prelink -av -mR -q

#LiveCD stuff (like creating user) is done by fedora-live-base.ks
#Modify LiveCD stuff, i.e. set autologin, enable installer (this is done in /etc/rc.d/init.d/livesys)
cat >> /etc/rc.d/init.d/livesys << EOF

#Set up autologin
sed -i '/^\[daemon\]/a AutomaticLoginEnable=true\nAutomaticLogin=liveuser' /etc/gdm/custom.conf

# don't use prelink on a running KDE live image
#sed -i 's/PRELINKING=yes/PRELINKING=no/' /etc/sysconfig/prelink # actually this forces prelink to run to undo prelinking (see /etc/sysconfig/prelink)
mv /usr/sbin/prelink /usr/sbin/prelink-disabled
rm /etc/cron.daily/prelink

#un-mute sound card (fixes some issues reported)
amixer set Master 85% unmute 2>/dev/null
amixer set PCM 85% unmute 2>/dev/null
pactl set-sink-mute 0 0
pactl set-sink-volume 0 50000

#chmod a+x /home/liveuser/Desktop/liveinst.desktop
chmod +x /usr/share/applications/liveinst.desktop
chown -Rf liveuser:liveuser /home/liveuser/Desktop
restorecon -R /home/liveuser/

#Turn off screensaver in live mode
gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory --type bool --set /apps/gnome-screensaver/idle_activation_enabled false

# disable screensaver locking
cat >> /usr/share/glib-2.0/schemas/org.gnome.desktop.screensaver.gschema.override << FOE
[org.gnome.desktop.screensaver]
lock-enabled=false
FOE

# and hide the lock screen option
cat >> /usr/share/glib-2.0/schemas/org.gnome.desktop.lockdown.gschema.override << FOE
[org.gnome.desktop.lockdown]
disable-lock-screen=true
FOE

# disable updates plugin
cat >> /usr/share/glib-2.0/schemas/org.gnome.settings-daemon.plugins.updates.gschema.override << FOE
[org.gnome.settings-daemon.plugins.updates]
active=false
FOE

# make the installer show up
if [ -f /usr/share/applications/liveinst.desktop ]; then
  # Show harddisk install in shell dash
  sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop ""
  # need to move it to anaconda.desktop to make shell happy
  #cp /usr/share/applications/liveinst.desktop /usr/share/applications/anaconda.desktop
  cat >> /usr/share/glib-2.0/schemas/org.korora.gschema.override << FOE
[org.gnome.shell]
favorite-apps=['firefox.desktop', 'evolution.desktop', 'vlc.desktop', 'shotwell.desktop', 'libreoffice-writer.desktop', 'nautilus.desktop', 'liveinst.desktop']
FOE
  cat >> /usr/share/glib-2.0/schemas/org.korora.gschema.override << FOE
[org.cinnamon]
favorite-apps=['cinnamon-settings.desktop', 'firefox.desktop', 'evolution.desktop', 'vlc.desktop', 'shotwell.desktop', 'libreoffice-writer.desktop', 'nautilus.desktop', 'liveinst.desktop']
FOE

  # Make the welcome screen show up
  if [ -f /usr/share/anaconda/gnome/fedora-welcome.desktop ]; then
    mkdir -p ~liveuser/.config/autostart
    cp /usr/share/anaconda/gnome/fedora-welcome.desktop /usr/share/applications/
    cp /usr/share/anaconda/gnome/fedora-welcome.desktop ~liveuser/.config/autostart/
    chown -R liveuser:liveuser /home/liveuser/.config/
  fi
fi

glib-compile-schemas /usr/share/glib-2.0/schemas

#disable yumupdatesd on live CD
#service yum-updatesd stop
systemctl stop yum-updatesd.service

#disable jockey from autostarting in live CD
rm /etc/xdg/autostart/jockey*

# Turn off PackageKit-command-not-found in live CD
if [ -f /etc/PackageKit/CommandNotFound.conf ]; then
  sed -i -e 's/^SoftwareSourceSearch=true/SoftwareSourceSearch=false/' /etc/PackageKit/CommandNotFound.conf
fi

EOF

#Clean up yum (shouldn't be neccessary)
#yum check-update
#yum -y update
#yum -y reinstall kororaa-extras kororaa-settings-gnome
#yum -y reinstall jockey jockey-gtk jockey-selinux
#rm -f /var/log/yum.log
#
##build yum db
#yum clean all
#yum check-update
#yum -y update
#yum provides */fake123
#rm -f /var/log/yum.log

pkcon get-packages
pkcon get-categories

echo waiting...
sleep 30

#Finally, clean up resolv.conf hack
echo "" > /etc/resolv.conf

%end

#%post --nochroot
#mount --bind /var/cache/yum $INSTALL_ROOT/var/cache/yum
#
#%end
