# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/phpsysinfo/phpsysinfo-2.1-r1.ebuild,v 1.12 2005/01/04 12:43:11 corsair Exp $

inherit eutils

MY_PN="phpSysInfo"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="phpSysInfo is a nice package that will display your system stats via PHP."
HOMEPAGE="http://phpsysinfo.sourceforge.net/"
SRC_URI="mirror://sourceforge/phpsysinfo/${MY_P}.tar.gz
	mirror://debian/pool/main/p/phpsysinfo/${PN}_${PV}-1.diff.gz"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~alpha hppa ~sparc amd64"

DEPEND=">=net-www/apache-1.3.27-r1
	>=dev-php/mod_php-4.2.3-r2"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${MY_P}.tar.gz
	epatch ${DISTDIR}/${PN}_${PV}-${PR/r}.diff.gz
	mv ${P}/debian ${S}
	rmdir ${P}
	epatch ${S}/debian/patches/urlencoded-security-fix.diff
}

src_install() {
	HTDOCS="/var/www/localhost/htdocs"
	insinto ${HTDOCS}/phpsysinfo
	doins *.{php,dtd}
	cp -pR templates ${D}${HTDOCS}/phpsysinfo
	cp -pR includes  ${D}${HTDOCS}/phpsysinfo
	dodoc COPYING  ChangeLog  README debian/patches/fix_memory_display_kernel2.5.diff
}

pkg_postinst() {
	einfo "Your stats are now available at http://yourserver/phpsysinfo"
	einfo "If you use a 2.5 kernel and want correct memory details output,"
	einfo "please apply /usr/share/doc/${PF}/fix_memory_display_kernel2.5.diff.gz"
	einfo "to the application."
}
