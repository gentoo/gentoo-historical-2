# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/php/php-5.0.4-r1.ebuild,v 1.2 2005/06/09 18:57:33 corsair Exp $

PHPSAPI="cli"
MY_PHP_P="php-${PV}"
PHP_S="${WORKDIR}/${MY_PHP_P}"
PHP_PACKAGE=1

inherit php5-sapi-r2 eutils

DESCRIPTION="PHP Shell Interpreter"
LICENSE="PHP"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
DEPEND="$DEPEND"
RDEPEND="$RDEPEND"
PROVIDE="virtual/php"
SLOT="0"

PHP_INSTALLTARGETS="${PHP_INSTALLTARGETS} install-cli"

src_unpack() {
	php5-sapi-r2_src_unpack
	# merged upstream
	#[ "${ARCH}" == "sparc" ] && epatch ${FILESDIR}/stdint.diff
	#EPATCH_OPTS="-p 1 -d ${S}" epatch ${FILESDIR}/${PN}-5.0.3-missing-arches.patch
	#EPATCH_OPTS="-p 0 -d ${S}" epatch ${FILESDIR}/libmbfl-headers.patch
}

src_compile () {
	my_conf="--disable-cgi --enable-cli --enable-embed"
	php5-sapi-r2_src_compile
}
