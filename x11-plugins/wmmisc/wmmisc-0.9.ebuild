# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmmisc/wmmisc-0.9.ebuild,v 1.4 2006/01/31 19:54:16 nelchael Exp $

IUSE=""

DESCRIPTION="WMaker DockApp to monitor the amount of users logged in, the total number of processes, the number of running processes, the total number of forks and the system load average."
HOMEPAGE="http://www.dockapps.org/file.php/id/160"
SRC_URI="http://www.dockapps.org/download.php/id/460/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"

RDEPEND="|| ( (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXpm )
	virtual/x11 )"
DEPEND="${RDEPEND}
	|| ( x11-proto/xextproto virtual/x11 )"

src_compile()
{
	emake CFLAGS="${CFLAGS}" || die "Compilation failed"
}

src_install()
{
	dodir /usr/bin
	einstall || die "Installation failed"
}
