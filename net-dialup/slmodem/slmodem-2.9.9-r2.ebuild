# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/slmodem/slmodem-2.9.9-r2.ebuild,v 1.4 2004/08/19 23:40:19 dragonheart Exp $

inherit kmod eutils

DESCRIPTION="Driver for Smart Link modem"
HOMEPAGE="http://www.smlink.com/"
SRC_URI="http://www.smlink.com/main/down/${P}.tar.gz"
LICENSE="Smart-Link"
SLOT="${KV}"
KEYWORDS="x86 -*"
IUSE="alsa usb"

DEPEND="virtual/libc
	alsa? ( media-libs/alsa-lib )
	virtual/os-headers"

RDEPEND="virtual/libc
	alsa? ( media-libs/alsa-lib )"

src_unpack() {

	ewarn "This ebuild is sensive to use flags (usb, alsa)."
	ewarn "Please select approprately based on your hardware."
	ewarn "use -usb if you have a PCI modem"

	# Unpack and set some variables
	kmod_src_unpack

	cd ${S}
	epatch ${FILESDIR}/${P}-makefile-fixup.patch
}

src_compile() {

	#[ -d ${KV_OUTPUT} ] || die "Build kernel ${KV_VERSION_FULL} first"

	export KERNEL_OUTPUT_DIR=${S}/workdir

	if is_kernel 2 5 || is_kernel 2 6
	then
		unset ARCH
	fi

	if use alsa
	then
		export SUPPORT_ALSA=1
	else
		export SUPPORT_ALSA=0
	fi

	mkdir ${S}/workdir

	emake -C ${S} \
		KERNEL_VER=${KV_VERSION_FULL} \
		KERNEL_DIR=${KV_OUTPUT} \
		KERNEL_INCLUDES=/usr/include/linux \
		all || die "Failed to compile driver"

}

#src_test() {
#	cd modem
#	emake modem_test
#	./modem_test || die "failed modem test"
#
#	if use usb
#	then
#	# USB modem test
#	else
#	# PCI modem test
#	fi
#}

src_install() {
	unset ARCH
	emake DESTDIR=${D} \
		KERNEL_VER=${KV_VERSION_FULL} \
		install-drivers install-test\
		|| die "driver install failed"

	mv ${D}/usr/sbin/modem_test ${D}/usr/sbin/slmodem_test

	dosbin modem/slmodemd
	dodir /var/lib/slmodem
	fowners root:dialout /var/lib/slmodem

	dodoc COPYING Changes README

	# Install /etc/{devfs,modules,init,conf}.d/slmodem files
	insinto /etc/conf.d/; newins ${FILESDIR}/${PN}-2.9.conf ${PN}
	insopts -m0755; insinto /etc/init.d/; newins ${FILESDIR}/${PN}-2.9.init ${PN}

	if use alsa
	then
		sed -i -e "s/# ALSACONF //g" ${D}/etc/conf.d/slmodem
	else
		sed -i -e "s/# NONALSACONF //g" ${D}/etc/conf.d/slmodem
		if use usb
		then
			sed -i -e "s/# USBCONF //g" ${D}/etc/conf.d/slmodem
		else
			sed -i -e "s/# PCICONF //g" ${D}/etc/conf.d/slmodem
		fi
	fi
	sed -i -e "s/ALSACONF//g" -e "s/PCICONF//g" -e "s/USBCONF//g" ${D}/etc/conf.d/slmodem


	# Make some devices if we aren't using devfs
	# If we are using devfs, restart it
	if [ -e ${ROOT}/dev/.devfsd ] ; then
	# devfs
		insinto /etc/devfs.d/; newins ${FILESDIR}/${PN}-2.9.devfs ${PN}
		insinto /etc/modules.d/; newins ${FILESDIR}/${PN}-2.9.modules ${PN}
	elif [ -e ${ROOT}/dev/.udev ] ; then
	# udev
		# check Symlink
		dodir /etc/udev/rules.d/
		echo 'KERNEL="slamr", NAME="slamr0"' > \
			 ${D}/etc/udev/rules.d/55-${PN}.rules
		echo 'KERNEL="slusb", NAME="slusb0"' >> \
			 ${D}/etc/udev/rules.d/55-${PN}.rules
		dodir /etc/udev/permissions.d
		echo 'slamr*:root:dialout:0660' > \
			${D}/etc/udev/permissions.d/55-${PN}.permissions
	else
		make -C drivers DESTDIR=${D} KERNELRELEASE=1 KERNEL_VER=${KV_VERSION_FULL} install-devices
	fi

	dodir /etc/hotplug

	#if [ -r ${ROOT}/etc/hotplug/blacklist ]
	#then
	#	cp ${ROOT}/etc/hotplug/blacklist ${D}/etc/hotplug/
	#fi

	dodir /etc/hotplug/blacklist.d
	echo -e "slusb\nslamr\nsnd-intel8x0m" >> ${D}/etc/hotplug/blacklist.d/55-${PN}
}

pkg_postinst() {
	kmod_pkg_postinst

	depmod -a

	# Make some devices if we aren't using devfs
	# If we are using devfs, restart it
	if [ -e ${ROOT}/dev/.devfsd ]
	then
		ebegin "Restarting devfsd to reread devfs rules"
			killall -HUP devfsd
		eend 0
		einfo "modules-update to complete configuration."

	elif [ -e ${ROOT}/dev/.udev ]
	then
		ebegin "Restarting udev to reread udev rules"
			udevstart
		eend 0
	fi

	echo

	einfo "You must edit /etc/conf.d/${PN} for your configuration"

	ewarn "To avoid problems add slusb/slamr to /etc/hotplug/blacklist"

	einfo "To add slmodem to your startup - type : rc-update add slmodem default"

	if use alsa;
	then
		einfo "I hope you have already added alsa to your startup: "
		einfo "otherwise type: rc-update add alsasound boot"
		einfo
		einfo "If you need to use snd-intel8x0m from the kernel"
		einfo "compile it as a module and edit /etc/module.d/alsa"
		einfo 'to: "alias snd-card-(number) snd-intel8x0m"'
	fi
}
