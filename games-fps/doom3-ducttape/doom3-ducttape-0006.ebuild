# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doom3-ducttape/doom3-ducttape-0006.ebuild,v 1.1.1.1 2005/11/30 09:39:45 chriswhite Exp $

inherit games

DESCRIPTION="sticks flashlights to your machinegun and shotgun"
HOMEPAGE="http://ducttape.glenmurphy.com/"
SRC_URI="http://ducttape.glenmurphy.com/ducttape${PV}.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

DEPEND="games-fps/doom3"

S=${WORKDIR}

src_install() {
	insinto "${GAMES_PREFIX_OPT}"/doom3/base
	doins pak008.pk4 || die "doins failed"
	insinto "${GAMES_PREFIX_OPT}"/doom3/d3xp
	doins pak002.pk4 || die "doins failed"
	newins readme.txt ${PN}-readme.txt
}
