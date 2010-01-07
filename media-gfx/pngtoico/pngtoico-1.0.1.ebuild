# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pngtoico/pngtoico-1.0.1.ebuild,v 1.2 2010/01/07 22:32:36 fauli Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Convert png images to MS ico format"
HOMEPAGE="http://www.kernel.org/pub/software/graphics/pngtoico/"
SRC_URI="mirror://kernel/software/graphics/pngtoico/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="media-libs/libpng"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-Makefile.patch
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	dobin pngtoico
	doman pngtoico.1
}
