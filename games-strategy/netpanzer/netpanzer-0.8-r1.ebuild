# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/netpanzer/netpanzer-0.8-r1.ebuild,v 1.2 2005/12/22 19:18:32 gustavoz Exp $

inherit eutils games

DATAVERSION="0.8"
DESCRIPTION="Fast-action multiplayer strategic network game"
HOMEPAGE="http://netpanzer.berlios.de/"
SRC_URI="http://download.berlios.de/netpanzer/netpanzer-${PV}.tar.bz2
	http://download.berlios.de/netpanzer/netpanzer-data-${DATAVERSION}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE="dedicated"

RDEPEND="dedicated? ( app-misc/screen )
	>=media-libs/libsdl-1.2.5
	>=media-libs/sdl-mixer-1.2.4
	>=media-libs/sdl-image-1.2.3
	>=dev-games/physfs-0.1.9"
DEPEND="${RDEPEND}
	>=dev-util/jam-2.5"

src_unpack() {
	unpack ${A}
	cd "${S}"
#	epatch "${FILESDIR}"/${P}-min-size-check.patch
#	epatch "${FILESDIR}"/${P}-robust.patch
}

src_compile() {
	egamesconf || die
	jam -q || die "jam failed"

	einfo "Working in ${WORKDIR}/${PN}-data-${DATAVERSION}/"
	cd "${WORKDIR}"/${PN}-data-${DATAVERSION}
	egamesconf || die
	jam -q || die "jam failed (on data package)"
}

src_install() {
	jam -sDESTDIR="${D}" -sappdocdir=/usr/share/doc/${PF} install || die "jam install failed"

	cd "${WORKDIR}"/${PN}-data-${DATAVERSION}/
	jam -sDESTDIR="${D}" -sappdocdir=/usr/share/doc/${PF} install || die "jam install failed (data package)"

	if use dedicated ; then
		newinitd "${FILESDIR}/netpanzer.rc" netpanzer || die "newinitd failed"
		sed -i \
			-e "s:GAMES_USER_DED:${GAMES_USER_DED}:" \
			-e "s:GENTOO_DIR:${GAMES_BINDIR}:" \
			"${D}/etc/init.d/netpanzer" \
			|| die "sed failed"

		insinto /etc
		doins "${FILESDIR}/netpanzer-ded.ini" || die "doins failed"
		exeinto "${GAMES_BINDIR}"
		doexe "${FILESDIR}/netpanzer-ded" || die "doexe failed"
		sed -i \
			-e "s:GENTOO_DIR:${GAMES_BINDIR}:" \
			"${D}${GAMES_BINDIR}/netpanzer-ded" \
			|| die "sed failed"
	fi
	make_desktop_entry netpanzer NetPanzer netpanzer.png
	prepgamesdirs
}
