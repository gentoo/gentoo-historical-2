# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-roguelike/tome/tome-2.3.3.ebuild,v 1.3 2006/10/08 20:54:22 tupone Exp $

inherit eutils flag-o-matic games

MY_PV=${PV//./}
DESCRIPTION="save the world from Morgoth and battle evil (or become evil ;])"
HOMEPAGE="http://t-o-m-e.net/"
SRC_URI="http://t-o-m-e.net/dl/src/tome-${MY_PV}-src.tar.bz2"

LICENSE="Moria"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc-macos ~x86"
IUSE="X Xaw3d gtk sdl"

RDEPEND=">=sys-libs/ncurses-5
	X? ( || ( x11-libs/libX11 virtual/x11 ) )
	Xaw3d? ( || ( x11-libs/libXaw virtual/x11 ) )
	sdl? (
		media-libs/sdl-ttf
		media-libs/sdl-image
		media-libs/libsdl
	)
	gtk? ( !amd64? ( =x11-libs/gtk+-1.2* ) )"
DEPEND="${REDEPEND}
	|| ( x11-misc/makedepend virtual/x11 )"

S="${WORKDIR}/tome-${MY_PV}-src"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc41.patch
	cd "src"
	mv makefile.std makefile
	epatch "${FILESDIR}/${PV}-gentoo-paths.patch"
	sed -i \
		-e "s:GENTOO_DIR:${GAMES_STATEDIR}:" files.c init2.c \
		|| die "sed failed"

	find "${S}" -name .cvsignore -exec rm -f \{\} \;
	find "${S}/lib/edit" -type f -exec chmod a-x \{\} \;
}

src_compile() {
	local GENTOO_INCLUDES="" GENTOO_DEFINES="-DUSE_GCU " GENTOO_LIBS="-lncurses"
	if use sdl || use X || use gtk || use Xaw3d; then
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_EGO_GRAPHICS -DUSE_TRANSPARENCY \
			-DSUPPORT_GAMMA"
	fi
	if use sdl || use X || use Xaw3d; then
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_PRECISE_CMOVIE -DUSE_UNIXSOCK "
	fi
	if use sdl; then
		GENTOO_INCLUDES="${GENTOO_INCLUDES} $(sdl-config --cflags)"
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_SDL "
		GENTOO_LIBS="${GENTOO_LIBS} $(sdl-config --libs) -lSDL_image -lSDL_ttf"
	fi
	if use X; then
		GENTOO_INCLUDES="${GENTOO_INCLUDES} -I/usr/X11R6/include "
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_X11 "
		GENTOO_LIBS="${GENTOO_LIBS} -L/usr/X11R6/lib -lX11 "
	fi
	if use Xaw3d; then
		GENTOO_INCLUDES="${GENTOO_INCLUDES} -I/usr/X11R6/include "
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_XAW "
		GENTOO_LIBS="${GENTOO_LIBS} -L/usr/X11R6/lib -lXaw -lXmu -lXt -lX11 "
	fi
	if use gtk; then
		if use amd64; then
			einfo "gtk support will not be built for amd64"
		else
			GENTOO_INCLUDES="${GENTOO_INCLUDES} $(gtk-config --cflags)"
			GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_GTK "
			GENTOO_LIBS="${GENTOO_LIBS} $(gtk-config --libs) "
		fi
	fi
	GENTOO_INCLUDES="${GENTOO_INCLUDES} -Ilua -I."
	GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_LUA"
	append-ldflags $(bindnow-flags)
	cd src
	make \
		INCLUDES="${GENTOO_INCLUDES}" \
		DEFINES="${GENTOO_DEFINES}" \
		depend || die "make depend failed"
	emake ./tolua || die "emake ./tolua failed"
	emake \
		COPTS="${CFLAGS}" \
		INCLUDES="${GENTOO_INCLUDES}" \
		DEFINES="${GENTOO_DEFINES}" \
		LIBS="${GENTOO_LIBS}" \
		BINDIR="${GAMES_BINDIR}" \
		LIBDIR="${GAMES_DATADIR}/${PN}" \
		|| die "emake failed"
}

src_install() {
	cd src
	make \
		DESTDIR="${D}" \
		OWNER="${GAMES_USER}" \
		BINDIR="${GAMES_BINDIR}" \
		LIBDIR="${GAMES_DATADIR}/${PN}" install \
		|| die "make install failed"
	cd "${S}"
	dodoc *.txt

	dodir "${GAMES_STATEDIR}"
	touch "${D}/${GAMES_STATEDIR}/${PN}-scores.raw"
	prepgamesdirs
	fperms g+w "${GAMES_STATEDIR}/${PN}-scores.raw"
	#FIXME: something has to be done about this.
	fperms g+w "${GAMES_DATADIR}/${PN}/data"
}

pkg_postinst() {
	games_pkg_postinst
	echo
	ewarn "ToME ${PV} is not save-game compatible with 2.3.0 and previous versions."
	echo
	einfo "If you have older save files and you wish to continue those games,"
	einfo "you'll need to remerge the version of ToME with which you started"
	einfo "those save-games."
}
