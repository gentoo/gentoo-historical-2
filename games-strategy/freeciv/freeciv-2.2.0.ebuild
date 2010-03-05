# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/freeciv/freeciv-2.2.0.ebuild,v 1.3 2010/03/05 20:23:25 mr_bones_ Exp $

EAPI=2
inherit eutils gnome2-utils games

DESCRIPTION="multiplayer strategy game (Civilization Clone)"
HOMEPAGE="http://www.freeciv.org/"
SRC_URI="mirror://sourceforge/freeciv/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="auth dedicated ggz gtk ipv6 nls readline sdl +sound"

RDEPEND="readline? ( sys-libs/readline )
	sys-libs/zlib
	app-arch/bzip2
	!dedicated? (
		nls? ( virtual/libintl )
		gtk? ( x11-libs/gtk+:2 )
		sdl? (
			media-libs/libsdl[video]
			media-libs/sdl-image[png]
			media-libs/freetype
		)
		!gtk? ( !sdl? ( x11-libs/gtk+:2 ) )
		sound? (
			media-libs/libsdl[audio]
			media-libs/sdl-mixer
		)
		ggz? ( dev-games/ggz-client-libs )
		media-libs/libpng
		auth? ( virtual/mysql )
	)"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	!dedicated? (
		nls? ( sys-devel/gettext )
		x11-proto/xextproto
	)"

src_prepare() {
	# install the .desktop in /usr/share/applications
	# install the icons in /usr/share/pixmaps
	sed -i \
		-e 's:^\(desktopfiledir = \).*:\1/usr/share/applications:' \
		-e 's:^\(icon[0-9]*dir = \)$(prefix)\(.*\):\1/usr\2:' \
		-e 's:^\(icon[0-9]*dir = \)$(datadir)\(.*\):\1/usr/share\2:' \
		client/Makefile.in \
		server/Makefile.in \
		data/Makefile.in \
		data/icons/Makefile.in \
		|| die "sed failed"

	# remove civclient manpage if dedicated server
	if use dedicated ; then
		epatch "${FILESDIR}"/${P}-clean-man.patch
	fi
}

src_configure() {
	local myclient

	if use dedicated ; then
		myclient="no"
	else
		use sdl && myclient="${myclient} sdl"
		use gtk && myclient="${myclient} gtk"
		[[ -z ${myclient} ]] && myclient="gtk" # default to gtk if none specified
	fi

	egamesconf \
		--disable-dependency-tracking \
		--localedir=/usr/share/locale \
		$(use_enable auth) \
		$(use_enable ipv6) \
		$(use_enable nls) \
		$(use_with readline) \
		$(use_enable sound sdl-mixer) \
		$(use_with ggz ggz-client) \
		--enable-client="${myclient}"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if ! use dedicated ; then
		# Create and install the html manual. It can't be done for dedicated
		# servers, because the 'civmanual' tool is then not built. Also
		# delete civmanual from the GAMES_BINDIR, because it's then useless.
		# Note: to have it localized, it should be ran from _postinst, or
		# something like that, but then it's a PITA to avoid orphan files...
		./manual/civmanual || die "civmanual failed"
		dohtml manual*.html || die "dohtml failed"
		rm -f "${D}/${GAMES_BINDIR}"/civmanual
		use sdl && make_desktop_entry freeciv-sdl "Freeciv (SDL)" freeciv-client
	fi

	dodoc ChangeLog NEWS doc/{BUGS,CodingStyle,HACKING,HOWTOPLAY,README*,TODO}

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
