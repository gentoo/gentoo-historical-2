# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdenetwork/kdenetwork-3.4.0_beta1.ebuild,v 1.6 2005/02/08 14:19:24 greg_g Exp $

inherit kde-dist eutils

DESCRIPTION="KDE network apps: kopete, kppp, kget..."

KEYWORDS="~x86 ~amd64"
IUSE="rdesktop slp ssl wifi"

DEPEND="~kde-base/kdebase-${PV}
	slp? ( net-libs/openslp )
	wifi? ( net-wireless/wireless-tools )"

RDEPEND="${DEPEND}
	rdesktop? ( >=net-misc/rdesktop-1.3.1-r1 )
	dev-lang/perl
	ssl? ( app-crypt/qca-tls
	       dev-perl/IO-Socket-SSL )"
# perl: for KSirc
# qca-tls: for Kopete jabber plugin.
# IO-Socket-SSL: for SSL support in KSirc.

src_compile() {
	myconf="$myconf $(use_enable slp)"
	use wifi || export DO_NOT_COMPILE="${DO_NOT_COMPILE} wifi"

	kde_src_compile
}

src_install() {
	kde_src_install

	chmod u+s ${D}/${KDEDIR}/bin/reslisa

	# empty config file needed for lisa to work with default settings
	dodir /etc
	touch ${D}/etc/lisarc

	# lisa, reslisa initscripts
	dodir /etc/init.d
	exeinto /etc/init.d
	sed -e "s:_KDEDIR_:${KDEDIR}:g" ${FILESDIR}/lisa > ${T}/lisa
	sed -e "s:_KDEDIR_:${KDEDIR}:g" ${FILESDIR}/reslisa > ${T}/reslisa
	doexe ${T}/lisa ${T}/reslisa

	insinto /etc/conf.d
	newins ${FILESDIR}/lisa.conf lisa
	newins ${FILESDIR}/reslisa.conf reslisa
}
