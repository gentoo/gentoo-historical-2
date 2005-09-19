# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/gweled/gweled-0.6.ebuild,v 1.2 2005/09/19 18:30:50 wolf31o2 Exp $

inherit eutils flag-o-matic games

DESCRIPTION="Bejeweled clone game"
HOMEPAGE="http://sebdelestaing.free.fr/gweled/"
SRC_URI="http://sebdelestaing.free.fr/gweled/Release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

DEPEND=">=x11-libs/gtk+-2
	>=gnome-base/librsvg-2
	>=gnome-base/libgnomeui-2"

src_unpack() {
	unpack ${A}
	# Adding gcc4 patch from halcy0n
	epatch ${FILESDIR}/${P}-gcc4.patch
}

src_compile() {
	filter-flags -fomit-frame-pointer
	econf || die "econf failed"

	sed -e 's/\(\$(scoredir)\)/\$(DESTDIR)\/\1/g' \
		-i Makefile || die "sed failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS
	prepgamesdirs
}
