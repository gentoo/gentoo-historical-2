# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/mythweb/mythweb-0.22_p22763-r1.ebuild,v 1.6 2010/05/11 20:49:07 josejx Exp $

EAPI=2
inherit mythtv webapp depend.php

DESCRIPTION="PHP scripts intended to manage MythTV from a web browser."
IUSE=""
KEYWORDS="amd64 ppc x86"

RDEPEND="dev-perl/DBI
	dev-perl/DBD-mysql
	dev-perl/Net-UPnP"

DEPEND="${RDEPEND}
		app-arch/unzip"

need_httpd_cgi
need_php5_httpd

pkg_setup() {
	webapp_pkg_setup
	require_php_with_use session mysql pcre posix json spl
}

src_prepare() {
	epatch "${FILESDIR}/${P}-ao-click.patch"
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	webapp_src_preinst

	cd "${S}"/mythweb
	dodoc README INSTALL

	dodir "${MY_HTDOCSDIR}"/data

	insinto "${MY_HTDOCSDIR}"
	doins -r [[:lower:]]*

	webapp_configfile "${MY_HTDOCSDIR}"/mythweb.conf.{apache,lighttpd}

	webapp_serverowned "${MY_HTDOCSDIR}"/data

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en-0.21.txt

	webapp_src_install
}
