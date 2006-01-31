# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmmemfree/wmmemfree-0.7-r1.ebuild,v 1.7 2006/01/31 19:48:13 nelchael Exp $

inherit eutils

IUSE=""
DESCRIPTION="A blue WMaker DockApp to see memory usage."
HOMEPAGE="http://misuceldestept.go.ro/wmmemfree/"
SRC_URI="ftp://ftp.ibiblio.org/pub/linux/X11/xutils/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ppc64 ~sparc"

RDEPEND="|| ( (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXpm )
	virtual/x11 )"
DEPEND="${RDEPEND}
	|| ( x11-proto/xextproto virtual/x11 )"

src_unpack()
{
	unpack ${A}
	cd ${S}

	# Patch to support both 2.4 and 2.6 kernels
	epatch ${FILESDIR}/${P}-add-kernel-26-support.patch
}

src_compile()
{
	FLAGS=${CFLAGS} make -e || die "Compilation failed"
}

src_install()
{
	dobin wmmemfree
	doman wmmemfree.1
	dodoc ChangeLog TODO WMS README THANKS
}
