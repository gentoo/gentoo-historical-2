# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/phpsysinfo/phpsysinfo-2.1.ebuild,v 1.2 2003/02/13 11:31:53 vapier Exp $

DESCRIPTION="phpSysInfo is a nice package that will display your system stats via PHP."
HOMEPAGE="http://phpsysinfo.sourceforge.net/"
SRC_URI="mirror://sourceforge/phpsysinfo/phpSysInfo-${PV}.tar.gz"
LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=">=apache-1.3.27-r1 >=mod_php-4.2.3-r2"
S=${WORKDIR}/phpSysInfo-${PV}

src_compile() { :; }

src_install() {
	insinto /home/httpd/htdocs/phpsysinfo
        doins *.{php,dtd}
	cp -pR templates ${D}/home/httpd/htdocs/phpsysinfo
	cp -pR includes ${D}/home/httpd/htdocs/phpsysinfo

}
pkg_postinst() {
        einfo
        einfo "Your stats are now availible at http://yoursever/phpsysinfo"
        einfo
}

