# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/eternal-lands/eternal-lands-1.3.0-r2.ebuild,v 1.1 2006/07/23 00:57:02 uberlord Exp $

inherit eutils games

MY_PV="${PV//_/}"
MY_PV="${MY_PV//./}"
S="${WORKDIR}/elc"
DESCRIPTION="An online MMORPG written in C and SDL"
HOMEPAGE="http://www.eternal-lands.com"
SRC_URI="mirror://gentoo/elc_${MY_PV}.tar.bz2
	mirror://gentoo/eternal-lands.png"

# NOTE: Sometimes you'll have to roll your own elc tarball from their CVS
# tree as they don't always release one.
# If they do then use this in SRC_URI instead
# ftp://ftp.berlios.de/pub/elc/elc_${MY_PV}.tgz

LICENSE="eternal_lands"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	|| ( (
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXext )
		virtual/x11 )
	virtual/opengl
	>=media-libs/libsdl-1.2.5
	>=media-libs/sdl-net-1.2.5
	~media-libs/openal-0.0.8
	media-libs/freealut
	media-libs/libvorbis
	>=dev-libs/libxml2-2.6.7
	|| ( =media-libs/cal3d-0.10.0 =media-libs/cal3d-0.11.0 )
	>=media-libs/libpng-1.2.8
	~games-rpg/${PN}-data-${PV}"

DEPEND="${RDEPEND}
	app-arch/unzip
	sys-apps/findutils
	doc? ( >=app-doc/doxygen-1.3.8
		>=media-gfx/graphviz-1.10 )"

src_unpack() {
	OPTIONS="OPTIONS=-DDATA_DIR="\\\\\"${GAMES_DATADIR}/${PN}/\\\\\"""
	S_CLIENT="${WORKDIR}/elc"
	BROWSER="konqueror"

	unpack ${A}
	cd "${S}"

	# Remove CVS entries
	find . -type d -name CVS -exec rm -rf {} \; 2>/dev/null

	# Create updated files with correct perms and allow dir creation
	epatch "${FILESDIR}/${P}-update-createdir.patch"

	# Get counters working
	epatch "${FILESDIR}/${P}-counters.patch"

	# Clean compile with all OpenAL versions
	epatch "${FILESDIR}/${P}-openal.patch"

	# Fix fonts
	epatch "${FILESDIR}/${P}-font.patch"

	use amd64 && OPTIONS="${OPTIONS} -DX86_64"
	sed \
		-e "s@CFLAGS=\$(PLATFORM) \$(CWARN) -O -ggdb -pipe@CFLAGS=${CFLAGS} @g"\
		-e "s@CXXFLAGS=\$(PLATFORM) \$(CXXWARN) -O -ggdb -pipe@CXXFLAGS=${CXXFLAGS} @g"\
		-e "s@OPTIONS=@${OPTIONS} @g" \
		-e 's/lopenal/lopenal -l alut/' \
		Makefile.linux > Makefile \
		|| die "sed failed"
	sed -i \
		-e 's/#browser/browser/g' \
		-e "s/browser = mozilla/#browser = ${BROWSER}/g" \
		-e "s@#data_dir = /usr/local/games/el/@#data_dir = ${GAMES_DATADIR}/${PN}/@g" \
		el.ini || die "sed failed"
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		emake docs || die "Failed to create documentation, try with USE=-doc"
		mv ./docs/html/ ../client || die "Failed to move documentation directory"
	fi
}

src_install() {
	newgamesbin el.x86.linux.bin el || die "newgamesbin failed"
	doicon "${DISTDIR}/eternal-lands.png"
	make_desktop_entry el "Eternal Lands"

	insopts -m 0660
	insinto "${GAMES_DATADIR}/${PN}"
	doins *.ini *.txt commands.lst || die "doins failed"

	if use doc ; then
		dohtml -r client/*
	fi

	prepgamesdirs
}

pkg_postinst() {
	einfo "Auto Update is now enabled in Eternal Lands"
	ewarn "If an update occurs then the client will suddenly exit"
	einfo "Updates only happen when the game first loads"
	einfo "Please don't report this behaviour as a bug"

	# Ensure that the files are writable by the game group for auto
	# updating.
	chmod -R g+rw "${ROOT}/${GAMES_DATADIR}/${PN}"

	# Make sure new files stay in games group
	find "${ROOT}/${GAMES_DATADIR}/${PN}" -type d -exec chmod g+sx {} \;
}
