# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/foremost/foremost-1.0.ebuild,v 1.1 2005/10/12 22:24:28 dragonheart Exp $

inherit toolchain-funcs

DESCRIPTION="A console program to recover files based on their headers and footers"
HOMEPAGE="http://foremost.sourceforge.net/"
SRC_URI="http://foremost.sourceforge.net/pkg/${P}.tar.gz"

KEYWORDS="~x86"
IUSE=""
LICENSE="public-domain"
SLOT="0"

RDEPEND="virtual/libc"

src_compile() {
	emake RAW_FLAGS="${CFLAGS}" RAW_CC="$(tc-getCC) -DVERSION=${PV}" \
		CONF=/etc || die "emake failed"
}

src_install() {
	dobin foremost
	doman foremost.1
	insinto /etc
	doins foremost.conf
	dodoc README CHANGES
}
