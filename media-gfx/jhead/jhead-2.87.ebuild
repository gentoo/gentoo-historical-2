# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/jhead/jhead-2.87.ebuild,v 1.2 2010/01/07 22:10:36 fauli Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Exif Jpeg camera setting parser and thumbnail remover"
HOMEPAGE="http://www.sentex.net/~mwandel/jhead"
SRC_URI="http://www.sentex.net/~mwandel/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

src_unpack() {
	# bug 275200 - respect flags and use mktemp instead of mkstemp
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${PN}-${PV}-respect_flags.patch
	epatch "${FILESDIR}"/${PN}-${PV}-mkstemp.patch
}

src_compile() {
	emake || die "emake failed."
}

src_install() {
	dobin ${PN} || die "dobin failed."
	dodoc *.txt
	dohtml *.html
	doman ${PN}.1
}
