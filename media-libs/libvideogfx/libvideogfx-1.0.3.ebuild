# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libvideogfx/libvideogfx-1.0.3.ebuild,v 1.4 2004/06/24 23:15:44 agriffis Exp $

DESCRIPTION="LibVideoGfx is a C++ library for low-level video processing."
HOMEPAGE="http://rachmaninoff.informatik.uni-mannheim.de/libvideogfx/index.html"
SRC_URI="http://rachmaninoff.informatik.uni-mannheim.de/libvideogfx/data/${P}.tar.gz"
LICENSE="LGPL-2.1"

SLOT="1.0"

KEYWORDS="~x86 ~ppc"

IUSE="mpeg"

DEPEND="virtual/glibc
		virtual/x11"

# Run-time dependencies, same as DEPEND if RDEPEND isn't defined:
#RDEPEND=""

S=${WORKDIR}/${P}

src_compile() {

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"

	emake || die
}

src_install() {

	make DESTDIR=${D} install || die


	dodoc AUTHORS BUGS ChangeLog INSTALL NEWS README TODO

}
