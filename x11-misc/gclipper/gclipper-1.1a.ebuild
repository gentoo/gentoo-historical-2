# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gclipper/gclipper-1.1a.ebuild,v 1.8 2002/12/09 04:41:51 manson Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="GClipper is a multiple buffer clipboard that automatically fetches new selections and maintains them in a history."
SRC_URI="http://www.thunderstorms.org/gclipper/gclipper-1.1a.tar.gz"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="http://www.theleaf.be"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc "

DEPEND="=x11-libs/gtk+-1.2*"

src_compile() {
	emake || die
}

src_install () {
	dobin gclipper
	dodoc Changelog COPYING README
}
