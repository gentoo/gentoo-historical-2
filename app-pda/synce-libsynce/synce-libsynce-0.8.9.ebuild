# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/synce-libsynce/synce-libsynce-0.8.9.ebuild,v 1.1 2004/03/26 12:34:10 tad Exp $

DESCRIPTION="Synchronize Windows CE devices with computers running GNU/Linux, like MS ActiveSync."
HOMEPAGE="http://sourceforge.net/projects/synce/"
SRC_URI="mirror://sourceforge/synce/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=""

src_compile() {
	econf
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README
}
