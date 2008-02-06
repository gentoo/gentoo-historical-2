# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/sitebar/sitebar-3.3.9-r1.ebuild,v 1.3 2008/02/06 14:43:18 angelos Exp $

inherit webapp eutils

MY_P=SiteBar-${PV}

DESCRIPTION="The Bookmark Server for Personal and Team Use"
HOMEPAGE="http://sitebar.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/httpd-cgi
	virtual/php"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	webapp_src_preinst
	dodoc readme.txt doc/history.txt doc/install.txt doc/troubleshooting.txt
	cp -R . "${D}/${MY_HTDOCSDIR}"
	rm -rf "${D}/${MY_HTDOCSDIR}/doc" "${D}/${MY_HTDOCSDIR}/readme.txt"

	webapp_serverowned "${MY_HTDOCSDIR}/inc"
	webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"

	webapp_src_install
}
