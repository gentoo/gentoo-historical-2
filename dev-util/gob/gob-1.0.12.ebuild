# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gob/gob-1.0.12.ebuild,v 1.7 2002/10/20 02:06:59 gerk Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GOB is a preprocessor for making GTK+ objects with inline C code"
SRC_URI="http://ftp.5z.com/pub/gob/${P}.tar.gz"
HOMEPAGE="http://www.5z.com/jirka/gob.html"

SLOT="1"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64"

RDEPEND="=dev-libs/glib-1.2*"
DEPEND="${RDEPEND}
	sys-devel/flex"

src_compile() {
	econf || die
	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}
