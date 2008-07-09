# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/surf/surf-1.0.5-r1.ebuild,v 1.1 2008/07/09 21:41:27 loki_val Exp $

inherit eutils base autotools

DESCRIPTION="a tool to visualize algebraic curves and algebraic surfaces"
HOMEPAGE="http://surf.sourceforge.net/"
SRC_URI="mirror://sourceforge/surf/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE="gtk"

RDEPEND="gtk? ( =x11-libs/gtk+-1.2* )
	>=dev-libs/gmp-2
	sys-libs/zlib
	media-libs/tiff
	media-libs/jpeg"

DEPEND="${RDEPEND}
	>=sys-devel/flex-2.5"

PATCHES=(	"${FILESDIR}/${P}-gcc43.patch"
		"${FILESDIR}/${P}-configurefixup.patch"	)

src_unpack() {
	base_src_unpack
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf $(use_enable gtk gui) || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install install-man || die

	dodoc AUTHORS ChangeLog NEWS README TODO
	for d in examples/*
	do
		docinto ${d}
		dodoc ${d}/*
	done
	prepalldocs
}
