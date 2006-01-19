# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xtermcontrol/xtermcontrol-2.7.ebuild,v 1.3 2006/01/19 00:48:33 spyderous Exp $

IUSE=""

DESCRIPTION="xtermcontrol enables dynamic control of XFree86 xterm properties."
SRC_URI="http://www.thrysoee.dk/xtermcontrol/${P}.tar.gz"
HOMEPAGE="http://www.thrysoee.dk/xtermcontrol/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ia64 ~ppc x86"

DEPEND=""

src_install () {
	make DESTDIR="${D}" install || die "install failed"
}
