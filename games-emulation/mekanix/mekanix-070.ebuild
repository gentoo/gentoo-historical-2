# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/mekanix/mekanix-070.ebuild,v 1.2 2006/02/11 04:46:30 joshuabaergen Exp $

inherit games

DESCRIPTION="SG-1000, SC-3000, SF-7000, SSC, SMS, GG, COLECO, and OMV emulator"
HOMEPAGE="http://www.smspower.org/meka/"
SRC_URI="http://www.smspower.org/meka/releases/${PN}${PV}.tgz"

LICENSE="mekanix"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="|| ( x11-libs/libXpm virtual/x11 )"

S=${WORKDIR}/${PN}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	doins * || die "doins failed"
	fperms a+x "${dir}/meka.exe"
	games_make_wrapper mekanix ./meka.exe "${dir}"
	prepgamesdirs
}
