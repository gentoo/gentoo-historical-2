# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/php-cvs/php-cvs-5.0.ebuild,v 1.3 2003/06/03 18:12:46 robbat2 Exp $

ECVS_SERVER="cvs.php.net:/repository"
ECVS_MODULE="php5"
ECVS_USER="cvsread"
ECVS_PASS="phpfi"
ECVS_AUTH="pserver"
ECVS_BRANCH=""

inherit php cvs

MY_P=php-${PV}
S=${WORKDIR}/${ECVS_MODULE}
DESCRIPTION="PHP Shell Interpreter - development version"
SRC_URI=""
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"
DEPEND="${DEPEND} 
	>=dev-util/re2c-0.9.1"

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
	
	cp sapi/cli/php .
	exeinto /usr/bin
	doexe php
			
	#We'll keep that as php4 for the mean time, to avoid accidents
	mv php.ini-dist php.ini
	insinto /etc/php4
	doins php.ini

	docinto Zend
	dodoc Zend/ZEND_CHANGES Zend/ChangeLog Zend/OBJECTS2_HOWTO
}

pkg_postinst() {
	# This fixes the permission from world writeable to the correct one.
	# - novell@kiruna.se
	chmod 755 /usr/bin/pear

	# This is more correct information.
	einfo 
	einfo "This is a CLI only build."
	einfo "You can not use it on a webserver."
	einfo 
}
