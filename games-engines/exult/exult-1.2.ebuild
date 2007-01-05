# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-engines/exult/exult-1.2.ebuild,v 1.10 2007/01/05 21:01:54 nyhm Exp $

WANT_AUTOCONF=latest
WANT_AUTOMAKE=latest
inherit eutils autotools games

DESCRIPTION="an Ultima 7 game engine that runs on modern operating systems"
HOMEPAGE="http://exult.sourceforge.net/"
SRC_URI="mirror://sourceforge/exult/${P}.tar.gz
	mirror://sourceforge/exult/U7MusicOGG_1of2.zip
	mirror://sourceforge/exult/U7MusicOGG_2of2.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"
IUSE="timidity zlib"

RDEPEND="media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/smpeg
	media-libs/libogg
	media-libs/libvorbis
	timidity? ( >=media-sound/timidity++-2 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	app-arch/unzip"

# upstream says... "the opengl renderer is very very experimental and
# not recommended for actual use"
#opengl? ( virtual/opengl )

src_unpack() {
	unpack ${P}.tar.gz
	mkdir music/
	cd music/
	unpack U7MusicOGG_{1,2}of2.zip
	cd "${S}"
	epatch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-64bits.patch \
		"${FILESDIR}"/${P}-x11link.patch
	sed -i \
		-e "s/u7siinstrics.data/u7siintrinsics.data/" \
		usecode/ucxt/data/Makefile.am \
		|| die "sed usecode/ucxt/data/Makefile.am failed"
	# This fix is needed for gimp-plugin support if we want to turn that on.
	#sed -i \
		#-e 's/$(DESTDIR)$(GIMP_PLUGINS) /$(GIMP_PLUGINS) $(DESTDIR)/' \
		#mapedit/Makefile.in \
		#|| die "sed mapedit/Makefile.in failed"
	eautoreconf
}

src_compile() {
	egamesconf \
		--disable-dependency-tracking \
		--disable-tools \
		--disable-opengl \
		--disable-3dnow \
		--disable-mmx \
		$(use_enable timidity) \
		$(use_enable zlib zip-support) \
		|| die
	emake || die "emake failed"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		desktopdir=/usr/share/applications/ \
		icondir=/usr/share/icons \
		install || die "emake install failed"
	# no need for this directory for just playing the game
	rm -rf "${D}${GAMES_DATADIR}/${PN}/estudio"
	dodoc AUTHORS ChangeLog NEWS FAQ README README.1ST
	insinto "${GAMES_DATADIR}/${PN}/music"
	doins "${WORKDIR}/music/"*ogg || die "doins failed"
	newdoc "${WORKDIR}/music/readme.txt" music-readme.txt
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "You *must* have the original Ultima7 The Black Gate and/or"
	elog "The Serpent Isle installed."
	elog "See /usr/share/doc/${PF}/README.gz for information!"
}
