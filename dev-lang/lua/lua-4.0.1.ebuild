# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/lua/lua-4.0.1.ebuild,v 1.3 2003/07/11 22:14:07 aliz Exp $

S=${WORKDIR}/lua-${PV}
DESCRIPTION="A powerful light-weight programming language designed for extending applications."
SRC_URI="http://www.lua.org/ftp/lua-${PV}.tar.gz"
HOMEPAGE="http://www.lua.org/"

SLOT="0"
KEYWORDS="x86 ~ppc ~sparc "
LICENSE="lua"


src_compile() {
	patch < ${FILESDIR}/lua-4.0-config.patch

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
