# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tclgpgme/tclgpgme-1.0.ebuild,v 1.10 2004/09/10 01:59:26 dragonheart Exp $

inherit eutils

DESCRIPTION="Tcl/Tk libraries to gpgme."
HOMEPAGE="http://beepcore-tcl.sourceforge.net/"
SRC_URI="http://beepcore-tcl.sourceforge.net/${P}.tgz"
IUSE=""
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 alpha ~sparc"

DEPEND=">=dev-lang/tcl-8.3.3
	>=dev-lang/tk-8.3.3
	=app-crypt/gpgme-0.3.14"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-Makefile.in.diff
}

src_compile() {
	econf --with-tcl=/usr/lib --with-tk=/usr/lib || die
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog INSTALL LICENSE README TODO
}
