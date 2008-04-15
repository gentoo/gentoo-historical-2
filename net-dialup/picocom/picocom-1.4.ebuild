# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/picocom/picocom-1.4.ebuild,v 1.5 2008/04/15 15:17:05 vapier Exp $

inherit eutils

DESCRIPTION="minimal dumb-terminal emulation program"
HOMEPAGE="http://efault.net/npat/hacks/picocom/"
SRC_URI="http://efault.net/npat/hacks/picocom/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
	sed -i -e 's:\./picocom:picocom:' pcasc
}

src_install() {
	dobin picocom pc{asc,xm,ym,zm} || die
	doman picocom.8
	dodoc CHANGES CONTRIBUTORS NEWS README TODO
}
