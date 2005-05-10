# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/fritzcapi/fritzcapi-2.6.32.ebuild,v 1.8 2005/05/10 15:55:41 genstef Exp $

inherit linux-mod rpm eutils

DESCRIPTION="SuSE's 2.6 AVM kernel modules for fcclassic, fcpci, fcpcmcia, fcpnp, fcusb, fcusb2, fxusb_CZ, fxusb, e2220pc and e5520pc"
HOMEPAGE="http://www.avm.de/"

#All sources in one suse-package
FRITZCAPI_MODULES=("fcpci" "fcpcmcia" "fcusb" "fcusb2" "fxusb" "fcclassic"
	"fcpnp" "fxusb_cz" "e2220pc" "e5520pc")
FRITZCAPI_TARGETS=("fritz.pci" "fritz.pcmcia" "fritz.usb" "fritz.usb2"
	"fritz.xusb" "fritz.classic" "fritz.pnp" "fritz.xusb_CZ" "e2220pc" "e5520pc")
for ((CARD=0; CARD < ${#FRITZCAPI_MODULES[*]}; CARD++)); do
	FRITZCAPI_SRC[${CARD}]="http://rpmfind.net/linux/SuSE-Linux/i386/current/suse/i586/km_${P/2.6./2.6-}.i586.rpm"
done

#get newer drivers for some cards from AVM
AVM_SRC=("fritzcrd.pci" "fritzcrd.pcm" "fritzcrd.usb" "fritzcrdusb.v20" "fritzx.usb")
AVM_FILES=("fcpci-suse9.1-3.11-02" "fcpcmcia-suse91-3.11-02"
	"fcusb-suse9.1-3.11-04" "fcusb2-suse9.1-3.11-04" "fxusb-suse9.1-3.11-04")
for ((CARD=0; CARD < ${#AVM_SRC[*]}; CARD++)); do
	FRITZCAPI_SRC[${CARD}]="ftp://ftp.avm.de/cardware/${AVM_SRC[CARD]}/linux/suse.91/${AVM_FILES[CARD]}.tar.gz"
done

#specific selection
for ((CARD=0; CARD < ${#FRITZCAPI_MODULES[*]}; CARD++)); do
	SRC_URI="${SRC_URI} fritzcapi_cards_${FRITZCAPI_MODULES[CARD]}? ( ${FRITZCAPI_SRC[CARD]} )"
done

#in case nothing is selected take all SRC_URI's
for ((CARD=0; CARD < ${#FRITZCAPI_MODULES[*]}; CARD++)); do
	BEGIN="${BEGIN} !fritzcapi_cards_${FRITZCAPI_MODULES[CARD]}? ("
	MIDDLE="${MIDDLE} ${FRITZCAPI_SRC[CARD]}"
	END="${END} )"
done
SRC_URI="${SRC_URI}${BEGIN}${MIDDLE}${END}"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="pcmcia usb"

DEPEND="net-dialup/capi4k-utils"

S="${WORKDIR}/usr/src/kernel-modules/fritzcapi"

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
	BUILD_PARAMS="KDIR=${KV_DIR} LIBDIR=${WORKDIR}/var/lib/fritz"
	BUILD_TARGETS="all"

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

src_unpack() {
	if [ -e ${DISTDIR}/km_${P/2.6./2.6-}.i586.rpm ]; then
		rpm_unpack ${DISTDIR}/km_${P/2.6./2.6-}.i586.rpm
	else mkdir -p ${S}; fi
	cd ${S}
	for ((CARD=0; CARD < ${#AVM_SRC[*]}; CARD++)); do
		if [ -e ${DISTDIR}/${AVM_FILES[CARD]}.tar.gz ]; then
			unpack ${AVM_FILES[CARD]}.tar.gz  || die "error unpacking ${AVM_FILES[CARD]}.tar.gz"
			CRD_NAME=${AVM_FILES[CARD]/-*}
			CRD_NAME=${CRD_NAME/fc}
			CRD_NAME=${CRD_NAME/f}
			[ -e fritz.${CRD_NAME} ] && mv fritz.${CRD_NAME} fritz.${CRD_NAME}.orig
			mv fritz fritz.${CRD_NAME}
		fi
	done

	if kernel_is ge 2 6 10 && [ -e fritz.pcmcia ]; then
		epatch ${FILESDIR}/${PN}-fix-for-2.6.10.patch
	fi

	for i in $(find . -name Makefile); do
		sed -i 's:-C \$(KDIR) SUBDIRS=:-C $(KDIR) $(if $(KBUILD_OUTPUT),O=$(KBUILD_OUTPUT)) SUBDIRS=:' ${i}
		convert_to_m ${i}
	done
}

src_install() {
	linux-mod_src_install

	dodir /lib/firmware /etc

	[ "${FRITZCAPI_BUILD_TARGETS/xusb_CZ/}" != "${FRITZCAPI_BUILD_TARGETS}" ] && \
		dodoc ${S}/fritz.xusb_CZ/README.fxusb_CZ

	[ "${FRITZCAPI_BUILD_TARGETS/usb2/}" != "${FRITZCAPI_BUILD_TARGETS}" ] && (
		insinto /lib/firmware
		insopts -m0644
		doins ${S}/fritz.usb2/*.frm
	)
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
