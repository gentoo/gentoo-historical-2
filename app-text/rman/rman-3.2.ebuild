# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/rman/rman-3.2.ebuild,v 1.5 2006/01/05 04:10:05 vapier Exp $

inherit eutils

DESCRIPTION="PolyGlotMan man page translator AKA RosettaMan"
HOMEPAGE="http://polyglotman.sourceforge.net/"
SRC_URI="mirror://sourceforge/polyglotman/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc-macos ~sh ~sparc ~x86"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PF}-gentoo.diff || die "patch failed"
}

src_install() {
	dobin ${PN} || die
	doman ${PN}.1
}
