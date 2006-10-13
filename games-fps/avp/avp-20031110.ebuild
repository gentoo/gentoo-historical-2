# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/avp/avp-20031110.ebuild,v 1.6 2006/10/13 17:02:16 wolf31o2 Exp $

#ECVS_SERVER="icculus.org:/cvs/cvsroot"
ECVS_PASS="anonymous"
ECVS_MODULE="avp"
#inherit eutils cvs games
inherit eutils multilib games

DESCRIPTION="Linux port of Aliens vs Predator"
HOMEPAGE="http://www.icculus.org/avp/"
SRC_URI="mirror://gentoo/avp-${PV}.tar.bz2"

LICENSE="AvP"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="media-libs/openal
	media-libs/libsdl"

S=${WORKDIR}/${ECVS_MODULE}

src_unpack() {
#	if [ "${ECVS_SERVER}" == "offline" ] ; then
		unpack ${A}
#	else
#		cvs_src_unpack
#	fi

	cd "${S}"

	sed -i \
		-e "/^CFLAGS =/s:=.*:=${CFLAGS}:" Makefile \
		|| die "sed Makefile failed"
	epatch "${FILESDIR}/${P}-gcc34.patch"
	epatch "${FILESDIR}/${P}-cleanup.patch"
	epatch "${FILESDIR}/${P}-gentoo.patch"
}

src_install() {
	dogamesbin AvP || die "dogamesbin failed"
	dodoc README TODO
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	einfo "please follow the instructions in"
	einfo "/usr/share/doc/${PF}/README.gz"
	einfo "to install the rest of the game"
}
