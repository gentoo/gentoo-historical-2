# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gclipper/gclipper-1.1a.ebuild,v 1.11 2004/05/06 17:47:51 tseng Exp $

DESCRIPTION="multiple buffer clipboard that automatically fetches new selections and maintains them in a history"
SRC_URI="http://www.thunderstorms.org/gclipper/gclipper-1.1a.tar.gz"
HOMEPAGE="http://www.theleaf.be/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc"
IUSE=""

DEPEND="=x11-libs/gtk+-1.2*"

S=${WORKDIR}/${PN}

src_compile() {
	emake || die
}

src_install() {
	dobin gclipper
	dodoc Changelog COPYING README
}
