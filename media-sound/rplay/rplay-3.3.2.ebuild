# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rplay/rplay-3.3.2.ebuild,v 1.10 2004/05/25 17:19:48 jhuebel Exp $

inherit flag-o-matic eutils

DESCRIPTION="Play sounds on remote Unix systems, without sending audio data over the network."
HOMEPAGE="http://rplay.doit.org/"
SRC_URI="http://rplay.doit.org/dist/${P}.tar.gz mirror://debian/pool/main/r/rplay/rplay_3.3.2-8.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 alpha sparc ppc amd64"
IUSE=""
DEPEND="virtual/glibc"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}

pkg_setup() {
		enewgroup "rplayd" ""
		enewuser "rplayd" "" "" "" "rplayd"
}

src_unpack() {
	unpack ${A}
	epatch ${WORKDIR}/rplay_3.3.2-8.diff
}

src_compile() {

	# fixing #36527
	append-flags -include errno.h

	econf	--enable-rplayd-user="rplayd" \
			--enable-rplayd-group="rplayd" || die "./configure failed"

	emake || die
}

src_install() {
	einstall || die
}
