# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gmanedit/gmanedit-0.3.3-r3.ebuild,v 1.6 2005/01/01 13:26:02 eradicator Exp $

inherit eutils

DESCRIPTION="Gnome based manpage editor"
SRC_URI="http://gmanedit.sourceforge.net/files/${P}.tar.bz2"
HOMEPAGE="http://gmanedit.sourceforge.net/"

KEYWORDS="x86 sparc ppc ~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="virtual/x11
	>=gnome-base/gnome-libs-1.4.1.4"

S=${WORKDIR}/${P}.orig

src_compile() {
	epatch ${FILESDIR}/${P}-xterm.patch
	econf --disable-nls || die "econf failed"
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog TODO README NEWS
}
