# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libiconv/libiconv-1.7.ebuild,v 1.8 2002/10/04 05:15:53 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="This is a required for GTK+ in GNOME2"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/libiconv/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/libiconv/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 sparc sparc64"

DEPEND="virtual/glibc"

src_compile() {
	econf || die
	mv man/Makefile man/Makefile.orig
	sed -e 's/mkdir/$(MKDIR)/' man/Makefile.orig > man/Makefile
	emake || die
}

src_install () {
	make MKDIR="mkdir -p" DESTDIR=${D} install || die
}
