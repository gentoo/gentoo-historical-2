# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/xgalaga/xgalaga-2.0.34-r4.ebuild,v 1.8 2004/06/24 22:14:18 agriffis Exp $

inherit eutils

DESCRIPTION="Galaga game clone."
HOMEPAGE="http://rumsey.org/xgal.html"
SRC_URI="http://http.us.debian.org/debian/pool/main/x/${PN}/${PN}_${PV}.orig.tar.gz
	http://http.us.debian.org/debian/pool/main/x/${PN}/${PN}_${PV}-27.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc alpha sparc amd64"
IUSE=""

DEPEND="virtual/x11"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${PN}_${PV}-27.diff
}

src_compile() {
	econf \
		--prefix=/usr/share/xgalaga \
		--bindir=/usr/bin || die
	emake CPPFLAGS="-D__NO_STRING_INLINES" || die "compile problem"
}

src_install() {
	dobin xgalaga || die
	dodoc README README.SOUND CHANGES INSTALL

	insinto /usr/share/xgalaga/sounds
	doins sounds/*.raw

	insinto /usr/share/xgalaga/levels
	doins levels/*.xgl

	exeinto /usr/share/xgalaga
	doexe xgal.sndsrv.linux

	touch ${D}/usr/share/xgalaga/scores
	fperms 660 /usr/share/xgalaga/scores
	fowners games:games /usr/share/xgalaga/scores
}
