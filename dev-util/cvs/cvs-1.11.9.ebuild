# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cvs/cvs-1.11.9.ebuild,v 1.2 2003/11/01 22:09:05 scandium Exp $

DESCRIPTION="Concurrent Versions System - source code revision control tools"
HOMEPAGE="http://www.cvshome.org/"
SRC_URI="http://ftp.cvshome.org/release/stable/${P}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha ~arm ~hppa ~amd64 ~ia64"

IUSE=""

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.1
	>=sys-libs/zlib-1.1.4"

src_compile() {
	econf --with-tmpdir=/tmp || die
	make || die
}

src_install() {
	einstall || die
	insinto /etc/xinetd.d
	newins ${FILESDIR}/cvspserver.xinetd.d cvspserver

	dodoc BUGS COPYING* ChangeLog* DEVEL* FAQ HACKING
	dodoc MINOR* NEWS PROJECTS README* TESTS TODO
	insinto /usr/share/emacs/site-lisp
	doins cvs-format.el
}
