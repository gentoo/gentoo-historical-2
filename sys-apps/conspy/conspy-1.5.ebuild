# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/conspy/conspy-1.5.ebuild,v 1.2 2007/11/01 16:16:24 drac Exp $

DESCRIPTION="Remote control for virtual consoles"
HOMEPAGE="http://ace-host.stuart.id.au/russell/files/conspy"
SRC_URI="http://ace-host.stuart.id.au/russell/files/${PN}/${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog README
	dohtml ${PN}.html
}
