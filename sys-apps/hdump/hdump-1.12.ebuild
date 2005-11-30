# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hdump/hdump-1.12.ebuild,v 1.1.1.1 2005/11/30 09:55:57 chriswhite Exp $

inherit eutils

DESCRIPTION="A hex \'od\' replacement for UNIX"
HOMEPAGE="http://www.fokus.gmd.de/research/cc/glone/employees/joerg.schilling/private/"
SRC_URI="http://ftp.berlios.de/pub/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""
DEPEND=""

src_compile() {
	make
}

src_install() {
	OBJ=${PN}/OBJ/`ls ${PN}/OBJ`
	dobin ${OBJ}/${PN}
	doman ${PN}/${PN}.1
}
