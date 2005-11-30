# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/synce-serial/synce-serial-0.8-r1.ebuild,v 1.1 2003/09/12 16:23:33 tad Exp $

DESCRIPTION="Synchronize Windows CE devices with computers running GNU/Linux, like MS ActiveSync."
HOMEPAGE="http://sourceforge.net/projects/synce/"
SRC_URI="mirror://sourceforge/synce/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=app-pda/synce-0.8
		 >=net-dialup/ppp-2.4.1"

src_compile() {
	econf
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README
}
