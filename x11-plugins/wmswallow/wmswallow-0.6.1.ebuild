# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmswallow/wmswallow-0.6.1.ebuild,v 1.9 2007/07/22 04:27:36 dberkholz Exp $

IUSE=""

DESCRIPTION="A dock applet to make any application dockable."
HOMEPAGE="http://burse.uni-hamburg.de/~friedel/software/wmswallow.html"
SRC_URI="http://burse.uni-hamburg.de/~friedel/software/wmswallow/${PN}.tar.Z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

RDEPEND="x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

S=${WORKDIR}/wmswallow

src_compile() {
	make xfree || die
}

src_install() {
	insinto /usr/bin
	doins wmswallow
	fperms 755 /usr/bin/wmswallow
	dodoc CHANGELOG README README.solaris todo
}
