# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/smbget/smbget-0.6.ebuild,v 1.6 2005/06/26 08:41:51 blubb Exp $

DESCRIPTION="a simple wget-like tool for the SMB/CIFS protocol"
HOMEPAGE="http://jelmer.vernstok.nl/oss/smbget/"
SRC_URI="http://jelmer.vernstok.nl/oss/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc x86"
IUSE=""

DEPEND="net-fs/samba
	dev-libs/popt"

src_compile() {
	emake || die
}

src_install() {
	dobin smbget || die
	doman smbget.1 smbgetrc.5
	dodoc AUTHORS ChangeLog README TODO smbgetrc
}
