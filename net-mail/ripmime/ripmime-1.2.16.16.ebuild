# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/ripmime/ripmime-1.2.16.16.ebuild,v 1.5 2002/10/04 06:09:30 vapier Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="ripMIME extracts attachment files out of a MIME-encoded email pack"
SRC_URI="http://www.pldaniels.com/ripmime/${P}.tar.gz"
HOMEPAGE="http://pldaniels.com/ripmime/"

SLOT="0"
LICENSE="Sendmail"
KEYWORDS="x86 sparc sparc64"

src_compile() {
	emake || die
}

src_install () {
	dobin ripmime
	dodoc CHANGELOG INSTALL LICENSE README TODO
}
