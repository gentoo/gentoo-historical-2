# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmpop3lb/wmpop3lb-2.4.2-r2.ebuild,v 1.3 2007/07/22 04:37:20 dberkholz Exp $

inherit eutils

IUSE=""

MY_P=${PN}${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="dockapp for checking up to 7 pop3 accounts"
HOMEPAGE="http://wmpop3lb.jourdain.org"
SRC_URI="http://lbj.free.fr/wmpop3/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A} ; cd ${S}/wmpop3

	sed -i -e "s:-g2 -D_DEBUG:${CFLAGS}:" Makefile

	#Fix bug #110683 - it is already included in the following patch
	#epatch ${FILESDIR}/${P}-socket-close.patch

	#Fix bug #161530
	epatch ${FILESDIR}/${P}-fix-RECV-and-try-STAT-if-LAST-wont-work.patch
}

src_compile() {
	emake -C wmpop3 || die "parallel make failed"
}

src_install() {
	dobin wmpop3/wmpop3lb
	dodoc CHANGE_LOG README
}
