# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/info2html/info2html-1.4.ebuild,v 1.1 2003/09/28 01:05:46 twp Exp $

DESCRIPTION="Converts GNU .info files to HTML"
HOMEPAGE="http://info2html.sourceforge.net/"
SRC_URI="mirror://sourceforge/info2html/${P}.tgz"
LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha arm hppa mips sparc x86"
DEPEND="dev-lang/perl"

inherit eutils
inherit webapp-apache

webapp-detect || NO_HTTPD=1

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/info2html-gentoo.patch
}

pkg_setup() {
	webapp-pkg_setup "${NO_HTTPD}"
	einfo "Installing into ${ROOT}${HTTPD_ROOT}"
}

src_install() {
	exeinto ${HTTPD_CGIBIN}
	doexe info2html infocat
	insinto ${HTTPD_CGIBIN}
	doins info2html.conf
	dodoc README
}

pkg_postinst() {
	einfo "Info files can be found at:"
	einfo "\thttp://localhost/cgi-bin/infocat"
}
