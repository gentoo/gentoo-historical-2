# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/git/git-4.3.20.ebuild,v 1.8 2004/06/28 03:37:22 vapier Exp $

DESCRIPTION="GNU Interactive Tools - increase speed and efficiency of most daily task"
HOMEPAGE="http://www.gnu.org/software/git/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="sys-devel/binutils"

src_install() {
	einstall || die
	dodoc AUTHORS INSTALL README NEWS VERSION STATUS
}
