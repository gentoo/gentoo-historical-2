# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdenetwork/kdenetwork-3.2.0_beta1.ebuild,v 1.1 2003/11/01 13:10:29 caleb Exp $
inherit kde-dist

IUSE="slp"
DESCRIPTION="KDE network apps: kmail, kppp, knode..."
KEYWORDS="~x86"
DEPEND="=kde-base/kdebase-${PV}"

use slp 	&& myconf="$myconf --enable-slp"	|| myconf="$myconf --disable-slp"

src_compile()
{
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
