# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/xsu/xsu-0.2.3.ebuild,v 1.3 2002/07/25 13:48:39 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Interface for 'su - username -c command' in GNOME."
SRC_URI="http://xsu.freax.eu.org/files/${P}.tar.gz"
HOMEPAGE="http://xsu.freax.eu.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="=gnome-base/gnome-libs-1.4* 
	=x11-libs/gtk+-1.2*
	=dev-libs/glib-1.2*"

src_compile() {

	# xsu uses its own custom configure script with unflexible Makefiles
	./configure \
		--prefix=/usr \
		--man-base=/usr/share/man \
		--doc-path=/usr/share/doc || die

	make CC="gcc ${CFLAGS}" || die

}

src_install() {
	dobin bin/xsu
	doman doc/man/xsu.8
	dodoc AUTHORS CHANGELOG COPYING INSTALL README
	dohtml -r doc
}
