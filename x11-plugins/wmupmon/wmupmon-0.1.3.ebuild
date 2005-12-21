# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmupmon/wmupmon-0.1.3.ebuild,v 1.1 2005/12/21 03:32:57 smithj Exp $

DESCRIPTION="wmUpMon is a program to monitor your Uptime"
HOMEPAGE="http://j-z-s.com/projects/index.php?project=wmupmon"
SRC_URI="http://j-z-s.com/projects/downloads/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~amd64 ~ppc ~ppc64"
IUSE=""
DEPEND="sys-devel/automake
	sys-devel/autoconf
	virtual/x11"

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
