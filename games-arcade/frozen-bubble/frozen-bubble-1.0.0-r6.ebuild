# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/frozen-bubble/frozen-bubble-1.0.0-r6.ebuild,v 1.4 2006/07/30 07:36:21 mr_bones_ Exp $

inherit eutils perl-module games

NET_CLIENT_P=frozen-bubble-client-0.0.3
NET_SERVER_P=frozen-bubble-server-0.0.3
DESCRIPTION="A Puzzle Bubble clone written in perl (now with network support)"
HOMEPAGE="http://www.frozen-bubble.org/ http://chl.tuxfamily.org/frozen-bubble/"
SRC_URI="http://guillaume.cottenceau.free.fr/fb/${P}.tar.bz2
	http://chl.tuxfamily.org/frozen-bubble/${NET_CLIENT_P}.tar.bz2
	http://chl.tuxfamily.org/frozen-bubble/${NET_SERVER_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.6.1
	>=media-libs/sdl-mixer-1.2.3
	dev-perl/sdl-perl"
DEPEND="${RDEPEND}
	sys-devel/autoconf"

pkg_setup() {
	if ! built_with_use -a media-libs/sdl-image gif png ; then
		ewarn "Frozen-bubble uses GIF and PNG image files."
		ewarn "You must emerge media-libs/sdl-image with GIF and PNG support."
		ewarn "Please USE=\"gif png\" emerge media-libs/sdl-image"
		die "Cannot emerge without gif and png USE flags on sdl-image"
	fi
	if ! built_with_use media-libs/sdl-mixer mikmod ; then
		ewarn "You must emerge media-libs/sdl-mikmod with mikmod support."
		ewarn "    USE=mikmod emerge media-libs/sdl-mikmod"
		die "missing mikmod USE flag for sdl-mixer"
	fi
	games_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	find . -type d -name .xvpics -print0 | xargs -0 rm -rf #bug #132227
	# main package
	epatch \
		"${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${PV}-no-chainreaction.patch \
		"${FILESDIR}"/${P}-{editor-,}sdl-perl-2.patch
	sed -i \
		-e 's:INSTALLDIRS=.*:PREFIX=${D}/usr:' \
		c_stuff/Makefile \
		|| die 'sed failed'

	# server addon
	cd "${WORKDIR}"/${NET_SERVER_P}
	sed -i \
		-e '/^dnl AM_CONFIG_HEADER/s:dnl ::' configure.in \
		|| die "sed failed"
	libtoolize -c -f || die "libtoolize failed"
	env \
		WANT_AUTOMAKE=1.4 \
		WANT_AUTOCONF=2.5 \
		./bootstrap.sh || die "bootstrap failed"
	echo '#include "config.h"' >> fb_serv.h

	# client addon
	cd "${WORKDIR}"/${NET_CLIENT_P}
	mv frozen-bubble-client frozen-bubble
	epatch "${FILESDIR}"/${P}-sdl-perl-2.patch
	mv frozen-bubble frozen-bubble-client
}

src_compile() {
	emake \
		OPTIMIZE="${CFLAGS}" \
		PREFIX=/usr \
		BINDIR="${GAMES_BINDIR}" \
		DATADIR="${GAMES_DATADIR}" \
		MANDIR=/usr/share/man \
		|| die "emake game failed"

	# server addon
	cd "${WORKDIR}"/${NET_SERVER_P}
	egamesconf || die
	emake || die "emake server failed"
}

src_install() {
	make \
		PREFIX="${D}/usr" \
		BINDIR="${D}/${GAMES_BINDIR}" \
		DATADIR="${D}/${GAMES_DATADIR}" \
		MANDIR="${D}/usr/share/man" \
		install \
		|| die "make install failed"
	dosed /usr/games/bin/frozen-bubble
	dodoc AUTHORS CHANGES README
	newicon icons/frozen-bubble-icon-48x48.png ${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN}.png

	# client addon
	cd "${WORKDIR}/${NET_CLIENT_P}"
	make \
		PREFIX="${D}/usr" \
		BINDIR="${D}/${GAMES_BINDIR}" \
		DATADIR="${D}/${GAMES_DATADIR}" \
		MANDIR="${D}/usr/share/man" \
		install \
		|| die "make install client failed"

	# server addon
	cd "${WORKDIR}/${NET_SERVER_P}"
	make \
		DESTDIR="${D}" \
		sbindir="${GAMES_BINDIR}" \
		install \
		|| die "make install server failed"
	dodoc TODO
	newdoc README README.server

	fixlocalpod
	prepgamesdirs
}
