# Copyriht 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-libs/paragui/paragui-1.0.2.ebuild,v 1.2 2002/07/11 06:30:39 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A cross-platform high-level application framework and GUI library"
SRC_URI="http://freesoftware.fsf.org/download/paragui/${P}.tar.gz"
HOMEPAGE="http://www.paragui.org"

DEPEND=">=media-libs/libsdl-1.2.4
        >=media-libs/sdl-image-1.2.1-r1
		dev-libs/expat"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man || die "configure failure"

	emake || die "Compile failure"
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING README README-ParaGUI.txt RELEASENOTES.final TODO THANKS
}
