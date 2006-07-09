# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/lua/lua-4.0.1.ebuild,v 1.12 2006/07/09 01:12:03 kumba Exp $

inherit eutils

S=${WORKDIR}/lua-${PV}
DESCRIPTION="A powerful light-weight programming language designed for extending applications."
SRC_URI="http://www.lua.org/ftp/lua-${PV}.tar.gz"
HOMEPAGE="http://www.lua.org/"
IUSE=""
SLOT="0"
KEYWORDS="mips ppc ~sparc x86"
LICENSE="lua"
DEPEND="virtual/libc"

src_compile() {
	epatch ${FILESDIR}/lua-4.0-config.patch

	emake || die
	make so || die
}

src_install () {
	make \
		INSTALL_BIN=${D}/usr/bin  \
		INSTALL_MAN=${D}/usr/share/man/man1 \
		INSTALL_INC=${D}/usr/include \
		INSTALL_LIB=${D}/usr/lib \
		install || die
}
