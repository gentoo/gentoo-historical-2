# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/synce-serial/synce-serial-0.11.ebuild,v 1.1 2008/11/13 06:18:49 mescalinum Exp $

DESCRIPTION="Synchronize Windows CE devices with Linux. Serial Library."
HOMEPAGE="http://sourceforge.net/projects/synce/"
SRC_URI="mirror://sourceforge/synce/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=net-dialup/ppp-2.4.1"

src_install() {
	make DESTDIR=${D} install || die "installation failed"
	dodoc README
}
