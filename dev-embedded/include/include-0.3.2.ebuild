# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/include/include-0.3.2.ebuild,v 1.7 2004/06/24 22:07:40 agriffis Exp $

DESCRIPTION="This is a collection of the useful independent include files for C/Assembler developers."
SRC_URI="mirror://sourceforge/openwince/${P}.tar.bz2"
HOMEPAGE="http://openwince.sourceforge.net/include/"
KEYWORDS="x86 sparc"
SLOT="0"
LICENSE="BSD"
IUSE=""
RESTRICT="nomirror"
DEPEND="sys-apps/grep
	sys-apps/gawk"

RDEPEND=""

src_compile(){
	econf || die "Failed to configure"
	emake || die "Failed to compile"
}

src_install(){
	emake DESTDIR=${D} install
}




