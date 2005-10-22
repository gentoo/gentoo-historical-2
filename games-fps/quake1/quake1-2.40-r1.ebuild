# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake1/quake1-2.40-r1.ebuild,v 1.3 2005/10/22 20:51:21 vapier Exp $

inherit eutils games

DESCRIPTION="The original Quake engine straight from id !"
HOMEPAGE="http://www.idsoftware.com/games/quake/quake/"
SRC_URI="ftp://ftp.idsoftware.com/idstuff/source/q1source.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="X opengl svga 3dfx"

RDEPEND="X? ( virtual/x11 )
	opengl? ( virtual/opengl )
	svga? ( media-libs/svgalib )
	3dfx? ( media-libs/glide-v3 )"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

pkg_setup() {
	games_pkg_setup
	echo
	ewarn "You probably want games-fps/quakeforge if you're"
	ewarn "looking for a quake1 client ..."
	ebeep
	esleep
}

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}"/fix-sys_printf.patch

	mv WinQuake/Makefile{.linuxi386,}
	mv QW/Makefile{.Linux,}

	epatch "${FILESDIR}"/makefile-path-fixes.patch
	epatch "${FILESDIR}"/gentoo-paths.patch
	sed -i -e "s:GENTOO_DATADIR:${GAMES_DATADIR}/quake-data:" \
		{QW/client,WinQuake}/common.c || die "setting data paths"

	epatch "${FILESDIR}"/makefile-cflags.patch
	sed -i "s:GENTOO_CFLAGS:${CFLAGS} -DGL_EXT_SHARED=1:" {WinQuake,QW}/Makefile

	cp QW/client/glquake.h{,.orig}
	(echo "#define APIENTRY";cat QW/client/glquake.h.orig) > QW/client/glquake.h

	epatch "${FILESDIR}"/makefile-sedable.patch
	if ! use 3dfx ; then
		sed -i 's:^   $(BUILDDIR)/bin/glquake ::' WinQuake/Makefile
		sed -i 's:^   $(BUILDDIR)/bin/glquake.3dfxgl ::' WinQuake/Makefile
		sed -i 's:^   $(BUILDDIR)/glqwcl ::' QW/Makefile
	fi
	if ! use X ; then
		sed -i 's:^   $(BUILDDIR)/bin/quake.x11 ::' WinQuake/Makefile
		sed -i 's:^   $(BUILDDIR)/qwcl.x11 ::' QW/Makefile
	fi
	if ! use opengl ; then
		sed -i 's:^   $(BUILDDIR)/bin/quake.glx ::' WinQuake/Makefile
		sed -i 's:^   $(BUILDDIR)/glqwcl.glx ::' QW/Makefile
	fi
	if ! use svga ; then
		sed -i 's:^   $(BUILDDIR)/bin/squake ::' WinQuake/Makefile
		sed -i 's:^   $(BUILDDIR)/qwcl ::' QW/Makefile
	fi
}

src_compile() {
	emake -j1 -C "${S}"/WinQuake build_release || die "failed to build WinQuake"
	emake -j1 -C "${S}"/QW build_release || die "failed to build QW"
}

src_install() {
	dogamesbin WinQuake/release*/bin/* QW/release*/*qw* || die "dogamesbin failed"
	dodoc readme.txt {WinQuake,QW}/*.txt
	prepgamesdirs
}
