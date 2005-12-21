# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/phpsysinfo/phpsysinfo-2.5.1.ebuild,v 1.1 2005/12/21 13:41:15 rl03 Exp $

inherit eutils webapp

DESCRIPTION="phpSysInfo is a nice package that will display your system stats via PHP."
HOMEPAGE="http://phpsysinfo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

S=${WORKDIR}/${PN}

DEPEND="$DEPEND
	>=virtual/httpd-php-4.3.8"

src_install() {
	webapp_src_preinst

	dodoc ChangeLog README
	cp -R [:it:]* ${D}${MY_HTDOCSDIR}
	cp config.php.new ${D}${MY_HTDOCSDIR}/config.php
	webapp_configfile ${MY_HTDOCSDIR}/config.php
	webapp_src_install
}
