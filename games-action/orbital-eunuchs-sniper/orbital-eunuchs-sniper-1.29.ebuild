# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/orbital-eunuchs-sniper/orbital-eunuchs-sniper-1.29.ebuild,v 1.6 2004/02/16 09:35:10 vapier Exp $

inherit eutils games

MY_PN=${PN//-/_}
DESCRIPTION="Snipe terrorists from your orbital base"
HOMEPAGE="http://icculus.org/oes/"
SRC_URI="http://filesingularity.timedoctor.org/${MY_PN}-${PV}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="x86 ppc"

RDEPEND=">=media-libs/libsdl-1.2.5-r1
	>=media-libs/sdl-mixer-1.2.5-r1
	>=media-libs/sdl-image-1.2.2"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

S=${WORKDIR}/${MY_PN}-${PV}

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e 's:datadir="$with_games_dir"::' configure \
		|| die "sed configure failed"
	cp -rf ${S}{,.orig}
	epatch ${FILESDIR}/${PV}-gentoo-paths.patch
	sed -i \
		-e "s:GENTOO_DIR:${GAMES_DATADIR}/${MY_PN}:" src/snipe2d.cpp \
		|| die "sed src/snipe2d.cpp failed"
}

src_compile() {
	egamesconf --with-games-dir=${GAMES_PREFIX} || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	rm -f ${D}/${GAMES_BINDIR}/*
	dodir ${GAMES_LIBDIR}/${PN}
	mv ${D}/${GAMES_DATADIR}/${MY_PN}/snipe2d.* ${D}/${GAMES_LIBDIR}/${PN}/ \
		|| die "mv failed"

	games_make_wrapper snipe2d ./snipe2d.x86.dynamic "${GAMES_LIBDIR}/${PN}"

	dodoc AUTHORS ChangeLog README TODO readme.txt
	prepgamesdirs
}
