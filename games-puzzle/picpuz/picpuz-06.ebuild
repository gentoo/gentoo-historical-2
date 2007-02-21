# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/picpuz/picpuz-06.ebuild,v 1.1 2007/02/21 18:36:38 mr_bones_ Exp $

inherit eutils games

DESCRIPTION="a jigsaw puzzle program"
HOMEPAGE="http://kornelix.squarespace.com/picpuz/"
SRC_URI="http://kornelix.squarespace.com/storage/picpuz/${PN}.${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.8"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e 's:-O3 -Wall:${CXXFLAGS}:' \
		picpuz-build.sh \
		|| die "sed failed"
	sed -i \
		-e "s:helppath);:\"/usr/share/doc/${PF}\");:" \
		picpuz.cpp \
		|| die "sed failed"
}

src_compile() {
	./picpuz-build.sh || die "build failed"
}

src_install() {
	newgamesbin ${PN}.x	${PN} || die "doexe failed"
	newicon ${PN}-icon.png ${PN}.png
	dodoc ${PN}-guide.pdf
	gunzip "${D}"/usr/share/doc/${PF}/picpuz-guide.pdf.gz
	make_desktop_entry ${PN} "Picpuz"
	prepgamesdirs
}
