# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/fritzcapi/fritzcapi-2.6.26.7-r3.ebuild,v 1.2 2004/12/22 23:22:27 mrness Exp $

inherit linux-mod rpm eutils

DESCRIPTION="SuSE's 2.6 AVM kernel modules for fcclassic, fcpci, fcpcmcia, fcpnp, fcusb, fcusb2, fxusb_CZ and fxusb"
HOMEPAGE="http://www.avm.de/"
SRC_URI="ftp://ftp.suse.com/pub/suse/i386/update/9.1/rpm/i586/km_${P/2.6./2.6-}.i586.rpm
	ftp://ftp.suse.com/pub/suse/i386/9.1/suse/i586/capi4linux-2004.4.5-0.i586.rpm"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="pcmcia usb"

DEPEND=">=net-dialup/capi4k-utils-20040810"

S="${WORKDIR}/usr/src/kernel-modules/fritzcapi"

FRITZCAPI_MODULES=("fcclassic" "fcpci" "fcpcmcia" "fcpnp" "fcusb" "fcusb2" "fxusb_CZ" "fxusb")
FRITZCAPI_TARGETS=("fritz.classic" "fritz.pci" "fritz.pcmcia" "fritz.pnp" "fritz.usb" "fritz.usb2" "fritz.xusb_CZ" "fritz.xusb")

BUILD_PARAMS="KDIR=${KV_DIR}"
BUILD_TARGETS="all"

get_card_module_name() {
	local CARD=$1
	echo "${FRITZCAPI_MODULES[CARD]}(extra:${S}/${FRITZCAPI_TARGETS[CARD]}/src)"
	if [ "${FRITZCAPI_MODULES[CARD]/pcmcia/}" != ${FRITZCAPI_MODULES[CARD]} ]; then
		#PCMCIA have also a *_cs module
		echo "${FRITZCAPI_MODULES[CARD]}_cs(extra:${S}/${FRITZCAPI_TARGETS[CARD]}/src)"
	fi
}

pkg_setup() {
	linux-mod_pkg_setup
	if ! kernel_is 2 6; then
		die "This package works only with 2.6 kernel!"
	fi
	if ! linux_chkconfig_present ISDN_CAPI_CAPI20; then
		die "For using the driver you need a kernel with enabled CAPI support."
	fi

	local USERCARD CARD
	FRITZCAPI_BUILD_CARDS=""
	FRITZCAPI_BUILD_TARGETS=""
	MODULE_NAMES=""
	if [ -n "${FRITZCAPI_CARDS}" ]; then
		#Check existence of user selected cards
		for USERCARD in ${FRITZCAPI_CARDS} ; do
			for ((CARD=0; CARD < ${#FRITZCAPI_MODULES[*]}; CARD++)); do
				if [ "${USERCARD}" = "${FRITZCAPI_MODULES[CARD]}" ]; then
					FRITZCAPI_BUILD_CARDS="${FRITZCAPI_BUILD_CARDS} ${FRITZCAPI_MODULES[CARD]}"
					FRITZCAPI_BUILD_TARGETS="${FRITZCAPI_BUILD_TARGETS} ${FRITZCAPI_TARGETS[CARD]}"
					MODULE_NAMES="${MODULE_NAMES} `get_card_module_name ${CARD}`"
					continue 2
				fi
			done
			die "Module ${USERCARD} not present in ${P}"
		done
	else
		einfo
		einfo "You can control the modules which are built with the variable"
		einfo "FRITZCAPI_CARDS which should contain a blank separated list"
		einfo "of a selection from the following cards:"
		einfo "   ${FRITZCAPI_MODULES[*]}"
		einfo
		ewarn "I give you the chance of hitting Ctrl-C and make the necessary"
		ewarn "adjustments in /etc/make.conf."
		ebeep

		#Filter build targets by USE
		for ((CARD=0; CARD < ${#FRITZCAPI_MODULES[*]}; CARD++)); do
			if [ "${FRITZCAPI_MODULES[CARD]/pcmcia/}" != ${FRITZCAPI_MODULES[CARD]} ] && ! useq pcmcia; then
				continue
			fi
			if [ "${FRITZCAPI_MODULES[CARD]/usb/}" != ${FRITZCAPI_MODULES[CARD]} ] && ! useq usb; then
				continue
			fi
			FRITZCAPI_BUILD_CARDS="${FRITZCAPI_BUILD_CARDS} ${FRITZCAPI_MODULES[CARD]}"
			FRITZCAPI_BUILD_TARGETS="${FRITZCAPI_BUILD_TARGETS} ${FRITZCAPI_TARGETS[CARD]}"
			MODULE_NAMES="${MODULE_NAMES} `get_card_module_name ${CARD}`"
		done
	fi

	einfo "Selected cards: ${FRITZCAPI_BUILD_CARDS}"
}

src_install() {
	linux-mod_src_install

	dodir /lib/firmware /etc

	echo -e "# card\tfile\tproto\tio\tirq\tmem\tcardnr\toptions" >${D}/etc/capi.conf
	echo "#" >>${D}/etc/capi.conf

	[ "${FRITZCAPI_BUILD_TARGETS/xusb_CZ/}" != "${FRITZCAPI_BUILD_TARGETS}" ] && \
		dodoc ${S}/fritz.xusb_CZ/README.fxusb_CZ

	[ "${FRITZCAPI_BUILD_TARGETS/usb2/}" != "${FRITZCAPI_BUILD_TARGETS}" ] && (
		insinto /lib/firmware
		insopts -m0644
		doins ${WORKDIR}/usr/lib/isdn/*
		echo -e "#fcusb2\tput_here_your_firmware\t-\t-\t-\t-\t-" >>${D}/etc/capi.conf
	)

	#Compatibility with <=net-dialup/isdn4k-utils-20041006-r3. 
	#Please remove it when it becomes obsolete
	dosym firmware /lib/isdn
}

pkg_postinst() {
	linux-mod_pkg_postinst

	einfo "If your device needs a firmware, you should edit copy the firmware files"
	einfo "in /lib/firmware and edit /etc/capi.conf."
	einfo
	[ "${FRITZCAPI_BUILD_TARGETS/usb2/}" != "${FRITZCAPI_BUILD_TARGETS}" ] && (
		einfo "Note: This ebuild has already installed firmware files necessary for following modules:"
		einfo "   fcusb2"
	)
}
