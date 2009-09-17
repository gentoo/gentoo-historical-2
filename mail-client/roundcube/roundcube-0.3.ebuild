# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/roundcube/roundcube-0.3.ebuild,v 1.3 2009/09/17 14:46:36 hollow Exp $

EAPI="2"

MY_PN="${PN}mail"
MY_P="${MY_PN}-${PV}-stable"

inherit eutils webapp depend.php depend.apache

DESCRIPTION="A browser-based multilingual IMAP client with an application-like user interface"
HOMEPAGE="http://roundcube.net"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

# roundcube is GPL-licensed, the rest of the licenses here are
# for bundled PEAR components, googiespell and utf8.class.php
LICENSE="GPL-2 BSD PHP-2.02 PHP-3 MIT public-domain"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="ldap mysql postgres sqlite ssl spell"

DEPEND=""
RDEPEND="
	spell? ( dev-lang/php[curl,spell] )
	dev-php/PEAR-PEAR
"

need_httpd_cgi
need_php_httpd

S=${WORKDIR}/${MY_P}

pkg_setup() {
	local flags="crypt iconv pcre session unicode spl"
	use ldap && flags="${flags} ldap"
	use ssl && flags="${flags} ssl"
	use spell && flags="${flags} curl spell"

	# check for required PHP features
	if ! use mysql && ! use postgres && ! use sqlite ; then
		local dbflags="mysql mysqli postgres sqlite"
		if ! PHPCHECKNODIE="yes" require_php_with_use ${flags} || \
			! PHPCHECKNODIE="yes" require_php_with_any_use ${dbflags} ; then
				die "Re-install ${PHP_PKG} with ${flags} and at least one of ${dbflags} in USE."
		fi
	else
		for db in postgres sqlite ; do
			use ${db} && flags="${flags} ${db}"
		done
		if ! PHPCHECKNODIE="yes" require_php_with_use ${flags} || \
			( use mysql && ! PHPCHECKNODIE="yes" require_php_with_any_use mysql mysqli ) ; then
				local diemsg="Re-install ${PHP_PKG} with ${flags}"
				use mysql && diemsg="${diemsg} and at least one of mysql mysqli"
				die "${diemsg} in USE"
		fi
	fi

	# add some warnings about optional functionality
	if ! PHPCHECKNODIE="yes" require_php_with_any_use gd gd-external ; then
		ewarn "IMAP quota display will not work correctly without GD support in PHP."
		ewarn "Recompile PHP with either gd or gd-external in USE if you want this feature."
		ewarn
	fi

	webapp_pkg_setup
}

src_prepare() {
	mv config/db.inc.php{.dist,}
	mv config/main.inc.php{.dist,}
}

src_install () {
	webapp_src_preinst
	dodoc CHANGELOG INSTALL README UPGRADING

	cp -R [[:lower:]]* SQL "${D}/${MY_HTDOCSDIR}"

	webapp_serverowned "${MY_HTDOCSDIR}"/logs
	webapp_serverowned "${MY_HTDOCSDIR}"/temp

	webapp_configfile "${MY_HTDOCSDIR}"/config/{db,main}.inc.php
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_postupgrade_txt en UPGRADING
	webapp_src_install
}
