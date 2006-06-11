# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/capi4k-utils/capi4k-utils-20050718-r1.ebuild,v 1.5 2006/06/11 18:11:30 sbriesen Exp $

inherit eutils multilib gnuconfig linux-info

YEAR_PV="${PV:0:4}"
MON_PV="${PV:4:2}"
DAY_PV="${PV:6:2}"
MY_P="${PN}-${YEAR_PV}-${MON_PV}-${DAY_PV}"
PPPVERSIONS="2.4.2 2.4.3"  # versions in portage

DESCRIPTION="CAPI4Linux Utils"
HOMEPAGE="ftp://ftp.in-berlin.de/pub/capi4linux/"
SRC_URI="ftp://ftp.in-berlin.de/pub/capi4linux/${MY_P}.tar.gz
	ftp://ftp.in-berlin.de/pub/capi4linux/OLD/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="fax pppd tcpd usb pcmcia"

DEPEND="virtual/linux-sources
	virtual/os-headers
	>=sys-apps/sed-4"

RDEPEND="usb? ( sys-apps/hotplug )
	pcmcia? ( virtual/pcmcia )
	dev-lang/perl"

S="${WORKDIR}/${PN}"

pkg_setup() {
	# check kernel config
	CONFIG_CHECK="ISDN ISDN_CAPI ISDN_CAPI_CAPI20"
	use pppd && CONFIG_CHECK="${CONFIG_CHECK} ISDN_CAPI_MIDDLEWARE ISDN_CAPI_CAPIFS_BOOL"
	linux-info_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# set our config
	cp -f "${FILESDIR}/config" .config
	# copy init-script config
	cp -f "${FILESDIR}/capi.confd" capi.confd
	# patch includes of all *.c files
	sed -i -e "s:linux/capi.h>$:linux/compiler.h>\n#include <linux/capi.h>:g" */*.c || die "sed failed"
	# patch all Makefile.* and Rules.make to use our CFLAGS
	sed -i -e "s:^\(CFLAGS.*\)-O2:\1${CFLAGS}:g" */Makefile.* */Rules.make || die "sed failed"
	# patch capi20/Makefile.* to use -fPIC for shared library
	sed -i -e "s:^\(CFLAGS.*\):\1 -fPIC:g" capi20/Makefile.* || die "sed failed"
	# patch pppdcapiplugin/Makefile to use only the ppp versions we want
	sed -i -e "s:^\(PPPVERSIONS = \).*$:\1${PPPVERSIONS}:g" pppdcapiplugin/Makefile || die "sed failed"
	# patch capiinit/capiinit.c to look also in /lib/firmware
	sed -i -e "s:\(\"/lib/firmware/isdn\",\):\1 \"/lib/firmware\",:g" capiinit/capiinit.c || die "sed failed"
	# no, we don't need any devices nodes
	sed -i -e "s:\(sh scripts/makedev.sh\):echo \1:g" Makefile || die "sed failed"
	# add --libdir to configure call in Makefile
	sed -i -e "s:\(\./configure \):\1--libdir=/usr/$(get_libdir) :g" Makefile || die "sed failed"
	# patch /usr/lib/pppd in pppdcapiplugin tree
	sed -i -e "s:/usr/lib/pppd:/usr/$(get_libdir)/pppd:g" \
		pppdcapiplugin/ppp-*/Makefile pppdcapiplugin/{README,*.8} || die "sed failed"

	# USB hotplug
	use usb || sed -i -e "s:^\(CAPI_HOTPLUG_.*\)$:### \1:g" capi.confd
	# build rcapid
	use tcpd || sed -i -e "s:^\(CONFIG_RCAPID=.*\)$:# \1:g" .config
	# build capifax
	use fax || sed -i -e "s:^\(CONFIG_CAPIFAX=.*\)$:# \1:g" .config
	# build pppdcapiplugin
	use pppd || sed -i -e "s:^\(CONFIG_PPPDCAPIPLUGIN=.*\)$:# \1:g" .config
}

src_compile() {
	gnuconfig_update
	emake subconfig || die "make subconfig failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	# fixing permissions (see bug #136120)
	fperms 0644 /usr/share/man/man8/capiplugin.8

	# install base
	dobin scripts/isdncause
	newinitd "${FILESDIR}/capi.initd" capi
	newconfd capi.confd capi
	insinto /etc
	doins "${FILESDIR}/capi.conf"
	dodoc "${FILESDIR}/README.gentoo" scripts/makedev.sh

	# install USB hotplug stuff
	if use usb; then
		insinto /etc/hotplug/blacklist.d
		newins "${FILESDIR}/capi.blacklist" capi
		insinto /etc/hotplug/usb
		newins "${FILESDIR}/capi.usermap" capi.usermap
		exeinto /etc/hotplug/usb
		newexe "${FILESDIR}/capi.hotplug" capi
	fi

	# install PCMCIA stuff
	if use pcmcia; then
		insinto /etc/pcmcia
		newins "${FILESDIR}/capi.pcmcia.conf" capi.conf
		exeinto /etc/pcmcia
		newexe "${FILESDIR}/capi.pcmcia" capi
	fi

	# install rcapid stuff
	if use tcpd; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/rcapid.xinetd" rcapid
		newdoc rcapid/README README.rcapid
	fi

	# install pppdcapiplugin stuff
	if use pppd; then
		insinto /etc/ppp/peers
		doins pppdcapiplugin/peers/t-dsl
		docinto pppdcapiplugin
		dodoc pppdcapiplugin/README pppdcapiplugin/examples/*
	fi
}

pkg_postinst() {
	einfo
	einfo "Please read the instructions in:"
	einfo "/usr/share/doc/${PF}/README.gentoo.gz"
	einfo
	einfo "Annotation for active AVM ISDN boards (B1 ISA/PCI, ...):"
	einfo "If you run"
	einfo "  emerge isdn-firmware"
	einfo "you will probably find your board's firmware in /lib/firmware."
	einfo
	einfo "If you have another active ISDN board, you should create"
	einfo "/lib/firmware and copy there your board's firmware."
	einfo
	einfo "There're several other packages available, which might have"
	einfo "the CAPI driver you need for your card(s):"
	einfo "  net-dialup/fritzcapi - AVM passive ISDN controllers"
	einfo "  net-dialup/fcdsl     - AVM ISDN/DSL controllers PCI/USB"
	einfo "  net-dialup/misdn     - some passive cards with HiSax chipset"
	einfo
	ewarn "If you're upgrading from an older capi4k-utils, you must recompile"
	ewarn "the other packages on your system that link with libcapi after the"
	ewarn "upgrade completes. To perform this action, please run revdep-rebuild"
	ewarn "in package app-portage/gentoolkit."
	ewarn
}
