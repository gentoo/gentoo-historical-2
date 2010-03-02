# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tipcutils/tipcutils-1.0.4.ebuild,v 1.4 2010/03/02 19:40:15 hwoarang Exp $

EAPI="2"

inherit eutils linux-info toolchain-funcs

DESCRIPTION="Utilities for TIPC (Transparent Inter-Process Communication)"
HOMEPAGE="http://tipc.sourceforge.net"
SRC_URI="mirror://sourceforge/tipc/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare(){
	epatch "${FILESDIR}"/${P}-cflags.patch
}

src_compile() {
	tc-export CC
	export KERNEL_DIR
	emake || die "emake failed."
}

src_install() {
	dosbin tipc-config
}
