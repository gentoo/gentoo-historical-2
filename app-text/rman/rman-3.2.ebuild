# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/rman/rman-3.2.ebuild,v 1.11 2006/04/09 14:28:56 flameeyes Exp $

inherit eutils toolchain-funcs

DESCRIPTION="PolyGlotMan man page translator AKA RosettaMan"
HOMEPAGE="http://polyglotman.sourceforge.net/"
SRC_URI="mirror://sourceforge/polyglotman/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ~mips ~ppc ~ppc-macos ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""
RESTRICT="test"

DEPEND=""

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PF}-gentoo.diff || die "patch failed"
	epatch "${FILESDIR}/${P}-ldflags.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin ${PN} || die
	doman ${PN}.1
}
