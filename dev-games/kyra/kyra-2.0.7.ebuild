# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/kyra/kyra-2.0.7.ebuild,v 1.7 2004/06/03 11:21:00 mr_bones_ Exp $

DESCRIPTION="Kyra Sprite Engine"
HOMEPAGE="http://www.grinninglizard.com/kyra/"
SRC_URI="mirror://sourceforge/kyra/kyra_src_${PV//./_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc"
IUSE="doc opengl"

DEPEND=">=media-libs/libsdl-1.2
	>=media-libs/sdl-image-1.2
	opengl? ( virtual/opengl )"

S="${WORKDIR}/${PN}"

src_compile() {
	econf $(use_with opengl) || die
	emake || die "emake failed"
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README
	dohtml docs/*
	use doc && dohtml -r docs/api
}
