# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/kaptain/kaptain-0.71.ebuild,v 1.4 2004/06/24 22:18:36 agriffis Exp $

inherit kde eutils

DESCRIPTION="A universal graphical front-end for command line programs"
HOMEPAGE="http://kaptain.sourceforge.net/"
SRC_URI="mirror://sourceforge/kaptain/kaptain-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~x86 ~ppc"

DEPEND=">=x11-libs/qt-2.3.1-r1"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-assert.patch
}

src_compile() {
	econf || die "kaptain config failed."
	emake || die
}

src_install() {
	einstall datadir=${D}/usr/share || die
	dodoc README ChangeLog TODO AUTHORS
}

