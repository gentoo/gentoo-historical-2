# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdenetwork/kdenetwork-3.2.3-r1.ebuild,v 1.10 2005/01/23 19:58:47 corsair Exp $

inherit kde-dist eutils

DESCRIPTION="KDE network apps: kopete, kppp, kget. kmail and knode are now in kdepim."

KEYWORDS="x86 ppc ~amd64 sparc hppa alpha ~ia64"
IUSE="slp samba wifi jabber ssl"

DEPEND="~kde-base/kdebase-${PV}
	slp? ( net-libs/openslp )
	samba? ( net-fs/samba )
	jabber? ( net-dns/libidn )
	ssl? ( app-crypt/qca-tls )
	!net-im/kopete
	wifi? ( net-wireless/wireless-tools )"

src_unpack() {
	kde_src_unpack
	epatch ${FILESDIR}/yahoo-fix-connect-062404.patch
}

src_compile() {
	myconf="$myconf `use_enable slp`"
	use wifi || DO_NOT_COMPILE="$DO_NOT_COMPILE wifi"
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
