# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/joe/joe-2.9.8_pre1.ebuild,v 1.3 2002/11/30 02:41:02 vapier Exp $

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A free ASCII-Text Screen Editor for UNIX"
SRC_URI="mirror://sourceforge/joe-editor/${MY_P}.tgz"
HOMEPAGE="http://sourceforge.net/projects/joe-editor/"

SLOT="0"
KEYWORDS="~x86 ppc ~sparc ~sparc64"
LICENSE="GPL-1"

DEPEND=">=sys-libs/ncurses-5.2-r2"

src_compile() {                           
	econf
	make || die
}

src_install() {                              
	einstall
	dodoc COPYING INFO LIST README TODO VERSION
}
