# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/openttd/openttd-20040626.ebuild,v 1.2 2004/07/03 02:13:53 mr_bones_ Exp $

inherit games

DESCRIPTION="OpenTTD is a clone of Transport Tycoon Deluxe"
HOMEPAGE="http://www.openttd.com/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	mirror://sourceforge/openttd/openttd-useful.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="debug png zlib"

DEPEND="virtual/libc
	media-libs/libsdl
	media-sound/timidity++
	media-sound/timidity-eawpatches
	png? ( media-libs/libpng )
	zlib? ( sys-libs/zlib )"

src_unpack() {
	unpack ${P}.tar.bz2

	# unpack the title screen
	mkdir "${WORKDIR}/useful"
	cd "${WORKDIR}/useful"
	unpack openttd-useful.zip

	# openttd doesn't create ~/.openttd/ so we must do that inside the wrapper
	cat << EOF > "${T}/openttd"
#!/bin/sh
test -d ~/.openttd/ || mkdir -p ~/.openttd
cd ${GAMES_BINDIR}
exec ./ttd -m extmidi "\$@"
EOF

}

src_compile() {
	local myopts="MANUAL_CONFIG=1 UNIX=1 WITH_SDL=1 WITH_NETWORK=1 USE_HOMEDIR=1 PERSONAL_DIR=.openttd GAME_DATA_DIR=${GAMES_DATADIR}/${PN}/"
	use debug && myopts="${myopts} DEBUG=1"
	use png && myopts="${myopts} WITH_PNG=1"
	use zlib && myopts="${myopts} WITH_ZLIB=1"

	emake -j1 ${myopts} || die "emake failed"
}

src_install() {
	dogamesbin "${T}/openttd" ttd || die "dogamesbin failed"

	insinto "${GAMES_DATADIR}/${PN}/data"
	doins data/* "${WORKDIR}/useful/opntitle.dat" || die "doins failed"

	insinto "${GAMES_DATADIR}/${PN}/lang"
	doins lang/*.lng || die "doins failed"

	insinto /usr/share/pixmaps
	newins media/icon128.png openttd.png

	make_desktop_entry openttd "OpenTTD" openttd.png
	dodoc readme.txt changelog.txt docs/Manual.txt
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	einfo "In order to play, you must copy the following 6 files from "
	einfo "the *WINDOWS* version of TTD to ${GAMES_DATADIR}/${PN}/data/"
	echo
	einfo "sample.cat trg1r.grf trgcr.grf trghr.grf trgir.grf trgtr.grf"
	echo
	einfo "If you want music, you must copy the gm/ directory"
	einfo "to ${GAMES_DATADIR}/${PN}/"
	echo
}
