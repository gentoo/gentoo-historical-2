# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/phpsysinfo/phpsysinfo-2.3.ebuild,v 1.3 2004/12/28 12:30:17 corsair Exp $

inherit eutils kernel-mod webapp

DESCRIPTION="phpSysInfo is a nice package that will display your system stats via PHP."
HOMEPAGE="http://phpsysinfo.sourceforge.net/"
SRC_URI="mirror://sourceforge/phpsysinfo/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~hppa ~sparc ~amd64 ~ppc64"
IUSE=""

DEPEND="$DEPEND >=net-www/apache-1.3.27-r1
	>=dev-php/mod_php-4.3.8"

S=${WORKDIR}/${PN}-dev

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	webapp_src_preinst

	cp -R templates ${D}${MY_HTDOCSDIR} || die "cp failed"
	cp -R includes ${D}${MY_HTDOCSDIR} || die "cp failed"
	cp *.php ${D}${MY_HTDOCSDIR} || die "cp failed"
	cp -R images ${D}${MY_HTDOCSDIR} || die "cp failed"

	cp config.php.new ${D}${MY_HTDOCSDIR}/config.php || die "cp failed"
	webapp_configfile ${MY_HTDOCSDIR}

	dodoc ChangeLog README

	webapp_src_install
}
