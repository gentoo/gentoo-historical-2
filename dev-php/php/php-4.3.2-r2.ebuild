# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/php/php-4.3.2-r2.ebuild,v 1.4 2004/01/08 06:25:10 robbat2 Exp $

PHPSAPI="cli"
inherit php eutils

IUSE="${IUSE} readline"

DESCRIPTION="PHP Shell Interpreter"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~hppa"

DEPEND="${DEPEND}
	readline? ( >=sys-libs/ncurses-5.1 >=sys-libs/readline-4.1 )
	ncurses? ( >=sys-libs/ncurses-5.1 )"

RDEPEND="${RDEPEND}"

src_compile() {
	php_securityupgrade

	# Readline and Ncurses are CLI PHP only
	use ncurses || use readline && use_ncurses="--with-" || use_ncurses="--without-"
	myconf="${myconf} `use_with readline`"
	myconf="${myconf} ${use_ncurses}-ncurses"

	myconf="${myconf} \
		--disable-cgi \
		--enable-cli"

	php_src_compile
}


src_install() {
	installtargets="${installtargets} install-cli"
	php_src_install

	# php executable is located in ./sapi/cli/
	exeinto /usr/bin
	doexe sapi/cli/php
}

pkg_postinst() {
	php_pkg_postinst
	php_securityupgrade
	einfo "This is a CLI only build."
	einfo "You can not use it on a webserver."
}
pkg_preinst() {
	php_pkg_preinst
}
