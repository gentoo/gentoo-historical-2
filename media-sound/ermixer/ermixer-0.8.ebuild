# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ermixer/ermixer-0.8.ebuild,v 1.10 2004/03/01 05:37:13 eradicator Exp $

DESCRIPTION="A full featured console-based audio mixer."
HOMEPAGE="http://ermixer.sourceforge.net"
LICENSE="GPL-2"

DEPEND=">=sys-libs/ncurses-5.2
		qt? ( x11-libs/qt )"

SLOT="0"
KEYWORDS="x86 ppc ~sparc alpha"

SRC_URI="mirror://sourceforge/ermixer/${P}.tar.gz"
S="${WORKDIR}/${P}"

src_compile() {
	local myconf

	use qt && myconf="--enable-qt=yes"
	econf ${myconf}|| die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README
}
