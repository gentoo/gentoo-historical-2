# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/setimgr/setimgr-0.04e.ebuild,v 1.4 2004/06/24 22:17:28 agriffis Exp $

DESCRIPTION="A SETI@home management program"
HOMEPAGE="http://www.arkady.demon.co.uk/seti/"
SRC_URI="http://www.arkady.demon.co.uk/seti/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=""
RDEPEND=">=app-sci/setiathome-3.08"

src_compile() {
	emake || die
#	mv simple_setup.sh setimgr-simple_setup.sh
}

src_install() {
	dodoc README
	newbin simple_setup.sh setimgr-simple_setup.sh
	dobin setimgr
}
