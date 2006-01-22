# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmSMPmon/wmSMPmon-2.3.ebuild,v 1.5 2006/01/22 12:05:43 nelchael Exp $

IUSE=""
DESCRIPTION="SMP system monitor dockapp"
HOMEPAGE="http://goupilfr.org/?soft=wmsmpmon"
SRC_URI="http://goupilfr.org/arch/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

RDEPEND="|| ( (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXpm )
	virtual/x11 )"
DEPEND="${RDEPEND}
	|| ( x11-proto/xextproto virtual/x11 )"

S="${WORKDIR}/${PN}-2.x/${PN}"

src_unpack()
{
	unpack ${A}
	cd ${S}
	sed -i -e "s:-Wall -O3 -m486:${CFLAGS}:" Makefile
}

src_compile()
{
	make || die "make failed"
}

src_install()
{
	dobin wmSMPmon
}
