# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/lua/lua-5.0.ebuild,v 1.10 2004/06/24 22:51:23 agriffis Exp $

DESCRIPTION="A powerful light-weight programming language designed for extending applications"
HOMEPAGE="http://www.lua.org/"
SRC_URI="http://www.lua.org/ftp/${P}.tar.gz"
LICENSE="MIT"
IUSE=""
SLOT="0"
KEYWORDS="~alpha hppa ~mips ppc sparc x86"
DEPEND=">=sys-apps/sed-4"

src_compile() {
	sed -i \
		-e 's:^#POPEN= -DUSE_POPEN$:POPEN= -DUSE_POPEN:' \
		-e "s:^MYCFLAGS= -O2:MYCFLAGS= ${CFLAGS}:" \
		-e 's:INSTALL_ROOT= /usr/local:INSTALL_ROOT= $(DESTDIR)/usr:' \
		-e 's:INSTALL_MAN= $(INSTALL_ROOT)/man/man1:INSTALL_MAN= $(INSTALL_ROOT)/share/man/man1:' \
		config || die "sed config failed"
	emake || die "emake failed"
	emake so || die "emake so failed"
}

src_install() {
	make DESTDIR=${D} install soinstall || die "make install soinstall failed"
	dodoc COPYRIGHT HISTORY README
	dohtml doc/*.html doc/*.gif
}
