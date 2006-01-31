# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmupmon/wmupmon-0.1.2.ebuild,v 1.8 2006/01/31 21:03:59 nelchael Exp $

DESCRIPTION="wmUpMon is a program to monitor your Uptime"
HOMEPAGE="http://j-z-s.com/projects/index.php?project=wmupmon"
SRC_URI="http://j-z-s.com/projects/downloads/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc amd64 ppc ppc64"
IUSE=""

RDEPEND="|| ( (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXt
		x11-libs/libXpm )
	virtual/x11 )"
DEPEND="${RDEPEND}
	|| ( x11-proto/xextproto virtual/x11 )"

src_compile()
{
	econf || die "configure failed"
	emake || die "parallel make failed"
}

src_install()
{
	einstall || die "make install failed"
	dodoc AUTHORS README THANKS ChangeLog
}
