# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/ripmime/ripmime-1.3.2.3.ebuild,v 1.2 2004/08/13 12:56:59 vapier Exp $

DESCRIPTION="extract attachment files out of a MIME-encoded email pack"
HOMEPAGE="http://pldaniels.com/ripmime/"
SRC_URI="http://www.pldaniels.com/ripmime/${P}.tar.gz"

LICENSE="Sendmail"
SLOT="0"
KEYWORDS="x86 ppc sparc"
IUSE=""

src_compile() {
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	dobin ripmime || die
	doman ripmime.1
	dodoc CHANGELOG INSTALL README TODO
}
