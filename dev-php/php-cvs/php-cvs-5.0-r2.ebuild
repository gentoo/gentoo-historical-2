# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/php-cvs/php-cvs-5.0-r2.ebuild,v 1.3 2004/06/25 01:23:47 agriffis Exp $

ECVS_SERVER="cvs.php.net:/repository"
ECVS_MODULE="php-src"
ECVS_USER="cvsread"
ECVS_PASS="phpfi"
ECVS_AUTH="pserver"
ECVS_BRANCH=""

PHPSAPI="cli"

inherit php cvs

MY_P=php-${PV}
S=${WORKDIR}/${ECVS_MODULE}
DESCRIPTION="PHP Shell Interpreter - development version"
SRC_URI=""
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"
DEPEND="${DEPEND}
	>=dev-util/re2c-0.9.1
	truetype? ( >=media-libs/t1lib-5.0.0 )
	"

src_unpack() {
	cvs_src_unpack
	cd ${S}
}

src_compile() {
	./buildconf

	myconf="${myconf} --enable-embed"
	myconf="${myconf} --disable-cgi --enable-cli"

	php_src_compile
}


src_install() {
	php_src_install

	exeinto /usr/bin
	doexe sapi/cli/php

	exeinto /usr/lib/
	doexe .libs/libphp5.so

	docinto Zend
	dodoc Zend/ZEND_CHANGES Zend/ChangeLog Zend/OBJECTS2_HOWTO
}

pkg_postinst() {
	einfo "This is a CLI only build."
	einfo "You can not use it on a webserver."
}
