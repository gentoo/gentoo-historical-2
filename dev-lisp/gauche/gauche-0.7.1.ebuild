# Copyright 2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/gauche/gauche-0.7.1.ebuild,v 1.1 2003/09/06 18:03:46 karltk Exp $

inherit flag-o-matic

# 2003-09-06: karltk
# Original submission used the non-exisiting utf8 flag, changed to nls for now
IUSE="ipv6 nls"
HOMEPAGE="http://gauche.sf.net"
DESCRIPTION="A Unix system friendly Scheme Interpreter"
SRC_URI="mirror://sourceforge/gauche/Gauche-${PV}.tgz"
LICENSE="BSD"
KEYWORDS="~x86"
SLOT="0"
S="${WORKDIR}/Gauche-${PV}"

DEPEND="virtual/glibc
	>=sys-libs/gdbm-1.8.0-r5"

src_compile() {
	local myconf

	use ipv6 && myconf="--enable-ipv6"

	if [ "`use nls`" ]; then
		myconf="$myconf --enable-multibyte=utf-8"
	else
		myconf="$myconf --enable-multibyte=euc-jp"
	fi

	sed -e "67s/\$(LIB_INSTALL_DIR)/\$(DISTDIR)\$(LIB_INSTALL_DIR)/" \
		src/Makefile.in > src/Makefile.in.tmp
	rm -f src/Makefile.in
	mv src/Makefile.in.tmp src/Makefile.in

	filter-flags -fforce-addr 

	CFLAGS="" CXXFLAGS="" econf $myconf --enable-threads=pthreads
	emake OPTFLAGS="$CFLAGS"

	make check
}

src_install () {
#	einstall
	make install DESTDIR=${D}

	dodoc AUTORS COPYING ChangeLog HACKING INSTALL INSTALL.eucjp README
}

