# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/php-cgi/php-cgi-4.3.11-r1.ebuild,v 1.1 2005/05/11 05:29:30 sebastian Exp $

PHPSAPI="cgi"
inherit php-sapi eutils

DESCRIPTION="PHP CGI"
SLOT="0"
KEYWORDS="x86 sparc alpha hppa ppc ia64 amd64 ~mips"

# for this revision only
PDEPEND=">=${PHP_PROVIDER_PKG}-4.3.11"
PROVIDE="${PROVIDE} virtual/httpd-php-${PV}"

src_unpack() {
	php-sapi_src_unpack

	# Bug 88756
	use flash && epatch ${FILESDIR}/php-4.3.11-flash.patch

	# Bug 88795
	use gmp && epatch ${FILESDIR}/php-4.3.11-gmp.patch
}

src_compile() {
	# CLI needed to build stuff
	myconf="${myconf} \
		--enable-cgi \
		--enable-cli \
		--enable-fastcgi \
		--enable-force-cgi-redirect"

	php-sapi_src_compile
}

src_install() {
	PHP_INSTALLTARGETS="install"
	php-sapi_src_install

	rm -f ${D}/usr/bin/php
	# rename binary
	newbin ${S}/sapi/cgi/php php-cgi
}

pkg_postinst() {
	php-sapi_pkg_postinst
	einfo "This is a CGI only build."
}
