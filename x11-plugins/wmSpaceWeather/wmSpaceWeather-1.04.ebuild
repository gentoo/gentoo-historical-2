# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmSpaceWeather/wmSpaceWeather-1.04.ebuild,v 1.13 2004/11/24 04:45:39 weeve Exp $

inherit eutils

IUSE=""
DESCRIPTION="dockapp showing weather at geosynchronous orbit."
HOMEPAGE="http://nis-www.lanl.gov/~mgh/WindowMaker/DockApps.shtml"
SRC_URI="http://nis-www.lanl.gov/~mgh/WindowMaker/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~mips hppa ppc ~sparc"

DEPEND="dev-lang/perl
		virtual/x11"

src_compile() {
	epatch ${FILESDIR}/getkp.patch
	emake -C wmSpaceWeather clean || die "make clean failed"

	COPTS=${CFLAGS} emake -C wmSpaceWeather \
		|| die "parallel make failed"
}

src_install() {
	dobin wmSpaceWeather/wmSpaceWeather wmSpaceWeather/GetKp
	doman wmSpaceWeather/wmSpaceWeather.1
	dodoc BUGS CHANGES HINTS README
}
