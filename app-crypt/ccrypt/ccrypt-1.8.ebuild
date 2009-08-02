# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/ccrypt/ccrypt-1.8.ebuild,v 1.3 2009/08/02 14:19:03 nixnut Exp $

DESCRIPTION="Encryption and decryption"
HOMEPAGE="http://ccrypt.sourceforge.net"
SRC_URI="http://ccrypt.sourceforge.net/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~x86"
IUSE=""

src_install () {
	emake \
		DESTDIR="${D}" \
		htmldir=/usr/share/doc/${PF} \
		install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
