# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/hostap/hostap-20021012-r1.ebuild,v 1.3 2003/02/28 02:50:02 latexer Exp $

inherit eutils

DESCRIPTION="HostAP wireless drivers"
HOMEPAGE="http://hostap.epitest.fi/"

PCMCIA_VERSION="`cardmgr -V 2>&1 | cut -f3 -d' '`"
MY_PCMCIA="pcmcia-cs-${PCMCIA_VERSION}"
SRC_URI="http://hostap.epitest.fi/releases/${PN}-2002-10-12.tar.gz
		pcmcia? ( mirror://sourceforge/pcmcia-cs/${MY_PCMCIA}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE="pcmcia"

DEPEND=">=net-wireless/wireless-tools-25
		pcmcia? ( >=sys-apps/pcmcia-cs-3.2.1* )"

S=${WORKDIR}/${PN}-2002-10-12
LIB_PATH="/lib/modules/${KV}"

if [ -z "${HOSTAP_DRIVERS}" ]; then
	CUSTOM="no"
	HOSTAP_DRIVERS="pci plx"
else
	CUSTOM="yes"
fi

src_unpack() {
	unpack ${A}
	cd ${S}

	# This is a patch that has already been applied to the hostap
	# cvs tree. It fixes hostapd compilation for gcc-3.2

	epatch ${FILESDIR}/${P}-gentoo-patch.diff

	mv Makefile ${T}
	sed -e "s:gcc:${CC}:" \
		-e "s:-O2:${CFLAGS}:" \
		-e "s:\$(EXTRA_CFLAGS):\$(EXTRA_CFLAGS) -DPRISM2_HOSTAPD:" \
		${T}/Makefile > Makefile
	
	if [ -n "`use pcmcia`" ] || [[ "${HOSTAP_DRIVERS}" == *pccard* ]]; then
		mv Makefile ${T}
		sed -e "s:^PCMCIA_PATH=:PCMCIA_PATH=${WORKDIR}/${MY_PCMCIA}:" \
			${T}/Makefile > Makefile
	fi
	
	cd ${S}/hostapd
	mv Makefile ${T}
	sed -e "s:gcc:${CC}:" \
		-e "s:-O2:${CFLAGS}:" \
		${T}/Makefile > Makefile
}

src_compile() {
	#
	# This ebuild now uses a system similar to the alsa ebuild.
	# By default, it will install the pci and plx drivers, and
	# the pcmcia drivers if pcmcia is in your use variables. To
	# specify exactly which drivers to build, do something like
	#
	#     HOSTAP_DRIVERS="pci pccard" emerge hostap
	#
	# Available options are pci, plx, and pccard.

	if [ "${CUSTOM}" == no ]; then
		if [ -n "`use pcmcia`" ]; then
			emake ${HOSTAP_DRIVERS} pccard hostap crypt || die
		else
			emake ${HOSTAP_DRIVERS} hostap crypt || die
		fi
	else
		einfo "Building the folowing drivers: ${HOSTAP_DRIVERS}"
		emake ${HOSTAP_DRIVERS} hostap crypt || die
	fi

	cd ${S}/hostapd
	emake || die
}

src_install() {
	dodir ${LIB_PATH}/net
	cp ${S}/driver/modules/{hostap.o,hostap_crypt.o,hostap_crypt_wep.o}\
		${D}${LIB_PATH}/net/

	if [ "${CUSTOM}" == "no" ]; then

		if [ -n "`use pcmcia`" ]; then
			dodir ${LIB_PATH}/pcmcia
			dodir /etc/pcmcia
			cp ${S}/driver/modules/hostap_cs.o ${D}/${LIB_PATH}/pcmcia/
			cp ${S}/driver/etc/hostap_cs.conf ${D}/etc/pcmcia/
			if [ -r /etc/pcmcia/prism2.conf ]; then
				einfo "You may need to edit or remove /etc/pcmcia/prism2.conf"
				einfo "This is usually a result of conflicts with the"
				einfo "linux-wlan-ng drivers."
			fi
		fi
		for driver in ${HOSTAP_DRIVERS}; do
			cp ${S}/driver/modules/hostap_${driver}.o\
				${D}${LIB_PATH}/net/;
		done
	elif [ "${CUSTOM}" == "yes" ]; then
		if [[ "${HOSTAP_DRIVERS}" = *pccard* ]]; then
			dodir ${LIB_PATH}/pcmcia
			dodir /etc/pcmcia
			cp ${S}/driver/modules/hostap_cs.o ${D}/${LIB_PATH}/pcmcia/
			cp ${S}/driver/etc/hostap_cs.conf ${D}/etc/pcmcia/
			if [ -r /etc/pcmcia/prism2.conf ]; then
				einfo "You may need to edit or remove /etc/pcmcia/prism2.conf"
				einfo "This is usually a result of conflicts with the"
				einfo "linux-wlan-ng drivers."
			fi
		fi

		if [[ "${HOSTAP_DRIVERS}" = *pci* ]]; then
			cp ${S}/driver/modules/hostap_pci.o\
				${D}${LIB_PATH}/net/
		fi

		if [[ "${HOSTAP_DRIVERS}" = *plx* ]]; then
			cp ${S}/driver/modules/hostap_plx.o\
				${D}${LIB_PATH}/net/
		fi

	fi

	dodoc FAQ README README.prism2 ChangeLog

	dosbin hostapd/hostapd
}
