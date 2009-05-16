# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/mawk/mawk-1.3.3.ebuild,v 1.13 2009/05/16 22:40:09 flameeyes Exp $

DESCRIPTION="an (often faster than gawk) awk-interpreter"
SRC_URI="ftp://ftp.whidbey.net/pub/brennan/${P}.tar.gz"
HOMEPAGE="http://freshmeat.net/projects/mawk/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~hppa ia64 ppc sparc x86 ~x86-fbsd"

DEPEND="virtual/libc"
IUSE=""

src_compile() {
	export MATHLIB="-lm"

	./configure --prefix=/usr || die "Failed to configure"
	emake -j1 || die "Make failed"
}

src_install () {
	dodir /usr/bin /usr/share/man/man1
	make BINDIR=${D}/usr/bin \
	     MANDIR=${D}/usr/share/man/man1 \
	     install || die "Install failed"
	dodoc ACKNOWLEDGMENT CHANGES COPYING INSTALL README
}
