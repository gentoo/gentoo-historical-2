# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/pcb/pcb-20050315.ebuild,v 1.1 2005/05/07 10:12:25 pbienst Exp $

DESCRIPTION="tool for the layout of printed circuit boards"
HOMEPAGE="http://pcb.sourceforge.net/"
SRC_URI="mirror://sourceforge/pcb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~sparc ~ppc"
IUSE="Xaw3d"

RDEPEND="virtual/x11"
DEPEND="${RDEPEND}
	=dev-lang/tk-8*"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's/\(^START-INFO\)/INFO-DIR-SECTION Miscellaneous\n\1/' doc/pcb.info
}

src_compile() {
	local myconf=""
	use Xaw3d \
		&& myconf="--with-xaw=Xaw3d" \
		|| myconf="--with-xaw=Xaw"
	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README
}
