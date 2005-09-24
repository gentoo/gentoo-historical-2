# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/linux-wlan-ng/linux-wlan-ng-0.2.1_pre23.ebuild,v 1.6 2005/09/24 09:10:59 blubb Exp $

inherit linux-info pcmcia

IUSE="build pcmcia usb"

MY_P=${PN}-${PV/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="The linux-wlan Project"
SRC_URI="
		ftp://ftp.linux-wlan.org/pub/linux-wlan-ng/${MY_P}.tar.bz2
		mirror://gentoo/${PN}-gentoo-init.gz"

HOMEPAGE="http://linux-wlan.org"
DEPEND="virtual/os-headers"
RDEPEND="dev-libs/openssl
		>=sys-apps/sed-4.0"

SLOT="0"
LICENSE="MPL-1.1"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"

src_unpack() {

	unpack ${MY_P}.tar.bz2
	unpack ${PN}-gentoo-init.gz

	# Use pcmcia.eclass to setup pcmcia-cs sources as needed
	pcmcia_src_unpack

	cp ${WORKDIR}/${PN}-gentoo-init ${S}/etc/rc.wlan

	cd ${S}
	epatch ${FILESDIR}/linux-wlan-2.6.10-fix.diff

	# Lots of sedding to do to get the man pages and a few other
	# things to end up in the right place.

	sed -i -e "s:/usr/local/man/:/usr/share/man/:" \
		man/Makefile

	sed -i -e "s:/etc/wlan:/etc/conf.d:g" \
		etc/wlan/Makefile

	sed -i -e "s:/sbin/nwepgen:/sbin/keygen:" \
		etc/wlan/wlancfg-DEFAULT

	sed -i -e "s:/etc/wlan/wlan.conf:/etc/conf.d/wlan.conf:g" \
	    -e "s:/etc/wlan/wlancfg:/etc/conf.d/wlancfg:g" \
		etc/wlan/shared

	if [ ${KV_MINOR} -gt 5 ] && [ ${KV_PATCH} -gt 5 ]
	then
		sed -i 's:SUBDIRS=:M=:g' ${S}/Makefile
	fi
}

src_compile() {
	# Configure the pcmcia-cs tree if it exists
	pcmcia_configure

	# now lets build wlan-ng
	cd ${S}

	sed -i -e 's:TARGET_ROOT_ON_HOST=:TARGET_ROOT_ON_HOST=${D}:' \
		-e 's:PRISM2_PCI=n:PRISM2_PCI=y:' \
		config.in

	if use pcmcia; then
		if [ -n "${PCMCIA_SOURCE_DIR}" ];
		then
			export PCMCIA_SOURCE_DIR=${PCMCIA_SOURCE_DIR}
			sed -i -e 's:PCMCIA_SRC=:PCMCIA_SRC=${PCMCIA_SOURCE_DIR}:' \
				config.in
		fi
		sed -i -e 's:PRISM2_PLX=n:PRISM2_PLX=y:' \
			config.in
	else
		sed -i -e 's:PRISM2_PCMCIA=y:PRISM2_PCMCIA=n:' \
		config.in
	fi

	if use usb; then
		sed -i -e 's:PRISM2_USB=n:PRISM2_USB=y:' \
			config.in
	fi

	cp config.in default.config

	# 2.6 needs ARCH unset since it uses it
	unset ARCH
	emake default_config || die "failed configuring WLAN"
	emake all || die "failed compiling"

	# compile add-on keygen program.  It seems to actually provide usable keys.
	cd ${S}/add-ons/keygen
	emake || die "Failed to compile add-on keygen program"
	cd ${S}/add-ons/lwepgen
	emake || die "Failed to compile add-on lwepgen program"
}

src_install () {

	make install || die "failed installing"

	dodir etc/wlan
	mv ${D}/etc/conf.d/shared ${D}/etc/wlan/

	if use build; then
		( cd ${D}/usr/share && rm -r man )
	fi

	exeinto /sbin
	doexe add-ons/keygen/keygen
	doexe add-ons/lwepgen/lwepgen

}

pkg_postinst() {
	depmod -a

	einfo "/etc/init.d/wlan is used to control startup and shutdown of non-PCMCIA devices."
	einfo "/etc/init.d/pcmcia from pcmcia-cs is used to control startup and shutdown of"
	einfo "PCMCIA devices."
	einfo ""
	einfo "Modify /etc/conf.d/wlan.conf to set global parameters."
	einfo "Modify /etc/conf.d/wlancfg-* to set individual card parameters."
	einfo "There are detailed instructions in these config files."
	einfo ""
	einfo "Three keygen programs are included: nwepgen, keygen, and lwepgen."
	einfo "keygen seems provide more usable keys at the moment."
	einfo ""
	einfo "Be sure to add iface_wlan0 parameters to /etc/conf.d/net."
	einfo ""
	ewarn "Wireless cards which you want to use drivers other than wlan-ng for"
	ewarn "need to have the appropriate line removed from /etc/pcmcia/wlan-ng.conf"
	ewarn "Do 'cardctl info' to see the manufacturer ID and remove the corresponding"
	ewarn "line from that file."
}


