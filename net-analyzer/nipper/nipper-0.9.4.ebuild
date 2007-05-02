# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nipper/nipper-0.9.4.ebuild,v 1.1 2007/05/02 21:14:55 ikelos Exp $

inherit toolchain-funcs eutils

DESCRIPTION="Script to parse and report on Cisco config errors"
HOMEPAGE="http://www.sourceforge.net/projects/nipper"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sys-libs/glibc"
RDEPEND="sys-libs/glibc"

RESTRICT="mirror"

src_compile() {
	epatch ${FILESDIR}/${P}-pix-xml.patch
	epatch ${FILESDIR}/${P}-banner-exclamation.patch

	cd ${S}
	$(tc-getCC) ${CFLAGS} ${PN}.c -o${PN}
}

src_install() {
	dobin ${PN}
	dodoc INSTALL LICENSE TODO Changelog
}
