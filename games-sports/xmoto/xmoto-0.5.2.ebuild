# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/xmoto/xmoto-0.5.2.ebuild,v 1.6 2009/11/20 14:41:56 maekke Exp $

EAPI=2
inherit eutils flag-o-matic games

LVL_PV="0.6.0" #they unfortunately don't release both at the same time, why ~ as separator :(
LVL="inksmoto-${LVL_PV}"
DESCRIPTION="A challenging 2D motocross platform game"
HOMEPAGE="http://xmoto.tuxfamily.org"
SRC_URI="http://download.tuxfamily.org/${PN}/${PN}/${PV}/${P}-src.tar.gz
	editor? ( http://download.tuxfamily.org/xmoto/svg2lvl/${LVL_PV}/${LVL}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="editor nls"

RDEPEND="
	dev-db/sqlite:3
	dev-games/ode
	dev-lang/lua[deprecated]
	media-libs/jpeg
	media-libs/libpng
	media-libs/libsdl[joystick]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	media-libs/sdl-net
	net-misc/curl
	app-arch/bzip2
	virtual/opengl
	virtual/glu
	media-fonts/dejavu
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	!=dev-db/sqlite-3.6.2
	nls? ( sys-devel/gettext )"
RDEPEND="${RDEPEND}
	editor? ( media-gfx/inkscape )"

src_prepare() {
	use editor && rm -vf "${WORKDIR}"/extensions/{bezmisc,inkex}.py
	sed -i \
		-e '/^gettextsrcdir/s:=.*:= @localedir@/gettext/po:' \
		po/Makefile.in.in \
		|| die "sed failed"
	epatch "${FILESDIR}"/${P}-64bit.patch
}

src_configure() {
	# bug #289792
	filter-flags -DdDOUBLE
	has_version 'dev-games/ode[double-precision]' && append-flags -DdDOUBLE

	egamesconf \
		--disable-dependency-tracking \
		--with-enable-zoom=1 \
		--enable-threads=posix \
		$(use_enable nls) \
		--localedir=/usr/share/locale \
		--with-localesdir=/usr/share/locale \
		--with-renderer-sdlGfx=0 \
		--with-renderer-openGl=1
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README TODO NEWS ChangeLog

	rm -f "${D}${GAMES_DATADIR}/${PN}"/Textures/Fonts/DejaVuSans.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSans.ttf "${GAMES_DATADIR}/${PN}"/Textures/Fonts/
	doicon extra/xmoto.xpm
	make_desktop_entry ${PN} Xmoto

	prepgamesdirs

	if use editor; then
		insinto /usr/share/inkscape/
		doins -r "${WORKDIR}"/extensions/ || die "doins failed"
	fi
}

pkg_postinst() {
	games_pkg_postinst
	if use editor; then
		elog "If you want to know how to create Xmoto levels"
		elog "have a look at this Tutorial:"
		elog "http://wiki.xmoto.tuxfamily.org/index.php?title=Inksmoto-${LVL_PV}"
		elog "You can share your levels on the Xmoto homepage."
	fi
}
