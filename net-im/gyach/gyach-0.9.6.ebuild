# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gyach/gyach-0.9.6.ebuild,v 1.3 2004/06/24 22:53:31 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GTK+-based Yahoo! chat client"
SRC_URI="http://www4.infi.net/~cpinkham/gyach/code/${P}.tar.gz"
HOMEPAGE="http://www4.infi.net/~cpinkham/gyach/"
KEYWORDS="x86 sparc "
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="virtual/glibc
	=x11-libs/gtk+-2*"

src_compile() {
	./configure --host=${CHOST} --prefix=/usr || die
	emake || die
}

src_install() {
	make prefix=${D}/usr install || die
	dodoc AUTHORS BUGS COPYING ChangeLog INSTALL README* TODO
	dodoc sample.*

	# install icon and desktop entry for gnome
	if use gnome ; then
		insinto /usr/share/pixmaps
		doins ${D}/usr/share/gyach/pixmaps/gyach-icon.xpm
		insinto /usr/share/gnome/apps/Internet
		doins ${FILESDIR}/gyach.desktop
	fi
}
