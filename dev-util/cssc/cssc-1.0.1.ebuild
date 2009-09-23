# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cssc/cssc-1.0.1.ebuild,v 1.5 2009/09/23 17:41:43 patrick Exp $

DESCRIPTION="CSSC is the GNU Project's replacement for SCCS"
SRC_URI="mirror://sourceforge/cssc/CSSC-${PV}.tar.gz"
HOMEPAGE="http://cssc.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2 LGPL-2"
S=${WORKDIR}/CSSC-${PV}
KEYWORDS="~amd64 x86"
IUSE=""
RESTRICT="test"

DEPEND=""

src_compile() {
	econf --enable-binary || die
	emake all || die
}

src_install () {
	make DESTDIR="${D}" install || die
	dodoc README NEWS ChangeLog AUTHORS
}
