# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gyach/gyach-0.7.5-r1.ebuild,v 1.7 2002/12/09 04:33:16 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GTK+-based Yahoo! chat client"
SRC_URI="http://www4.infi.net/~cpinkham/gyach/code/${P}.tar.gz"
HOMEPAGE="http://www4.infi.net/~cpinkham/gyach/"
KEYWORDS="x86 sparc "
LICENSE="GPL-2"
SLOT="0"

DEPEND="=x11-libs/gtk+-1.2*"

src_compile() {
	./configure --host=${CHOST} --prefix=/usr || die
	emake || die
}

src_install() {
  	make prefix=${D}/usr install || die
	dodoc AUTHORS BUGS COPYING ChangeLog NEWS README* TODO

	# install icon and desktop entry for gnome
	if [ "`use gnome`" ] ; then
		insinto /usr/share/pixmaps
		doins ${D}/usr/share/gyach/pixmaps/gyach-icon.xpm
		insinto /usr/share/gnome/apps/Internet
		doins ${FILESDIR}/gyach.desktop
	fi

}
