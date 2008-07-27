# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/r-katro/r-katro-0.7.0.ebuild,v 1.11 2008/07/27 20:58:23 carlo Exp $

EAPI=1

inherit eutils qt3 games

DESCRIPTION="3D puzzle game"
HOMEPAGE="http://f.rodrigo.free.fr/games/r-katro/r-katro.php"
SRC_URI="http://f.rodrigo.free.fr/r-tech/cmp/addon-module/link/link.php?games/r-katro/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="nls"

RDEPEND="x11-libs/qt:3
	virtual/glut
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc43.patch
	sed -i \
		's:$(localedir):/usr/share/locale:' \
		$(find . -name 'Makefile.in*') \
		|| die "sed failed"
}

src_compile() {
	egamesconf $(use_enable nls) || die
	mkdir src/moc src/helpviewer/moc
	emake CXXFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README TODO
	prepgamesdirs
}
