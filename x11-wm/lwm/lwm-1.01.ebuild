# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/lwm/lwm-1.01.ebuild,v 1.8 2003/02/13 17:50:20 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="The ultimate lightweight window manager"
SRC_URI="http://www.boognish.org.uk/enh/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.boognish.org.uk/enh/lwm/"
KEYWORDS="x86 sparc ~ppc"

DEPEND="x11-base/xfree"

SLOT="0"
LICENSE="GPL-2"

src_compile() {

	xmkmf || die
	emake lwm || die
}

src_install() {

	einstall \
		BINDIR=${D}/usr/bin || die

	dodoc COPYRIGHT ChangeLog TODO
}
