# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdenetwork/kdenetwork-3.3.2.ebuild,v 1.10 2005/02/08 14:19:24 greg_g Exp $

inherit kde-dist eutils

DESCRIPTION="KDE network apps: kopete, kppp, kget..."

KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="slp samba wifi ssl"

DEPEND="~kde-base/kdebase-${PV}
	slp? ( net-libs/openslp )
	samba? ( net-fs/samba )
	ssl? ( app-crypt/qca-tls )
	wifi? ( net-wireless/wireless-tools )"

src_unpack() {
	kde_src_unpack
}

src_compile() {
	myconf="$myconf `use_enable slp`"
	use wifi || DO_NOT_COMPILE="$DO_NOT_COMPILE wifi"
	export DO_NOT_COMPILE
	kde_src_compile
}

src_install() {
	kde_src_install

	chmod +s ${D}/${KDEDIR}/bin/reslisa

	# empty config file needed for lisa to work with default settings
	touch ${D}/etc/lisarc

	# lisa, reslisa initscripts
	dodir /etc/init.d
	sed -e "s:_KDEDIR_:${KDEDIR}:g" ${FILESDIR}/lisa > ${D}/etc/init.d/lisa
	sed -e "s:_KDEDIR_:${KDEDIR}:g" ${FILESDIR}/reslisa > ${D}/etc/init.d/reslisa
	chmod +x ${D}/etc/init.d/*

	insinto /etc/conf.d
	newins ${FILESDIR}/lisa.conf lisa
	newins ${FILESDIR}/reslisa.conf reslisa
}
