# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cvs/cvs-1.11.14.ebuild,v 1.4 2004/03/27 23:23:30 pyrania Exp $

inherit eutils flag-o-matic

DESCRIPTION="Concurrent Versions System - source code revision control tools"
HOMEPAGE="http://www.cvshome.org/"
SRC_URI="http://ftp.cvshome.org/release/stable/${P}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc ~mips ~alpha hppa ~amd64 ~ia64 ~ppc64"

IUSE=""

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.1
	>=sys-libs/zlib-1.1.4"

pkg_setup() {
	enewgroup cvs
	enewuser cvs -1 /bin/false /var/cvsroot cvs
}

src_compile() {
	use alpha && append-flags -fPIC

	econf --with-tmpdir=/tmp || die
	emake || die "emake failed"
}

src_install() {
	einstall || die

	keepdir /var/cvsroot

	insinto /etc/xinetd.d
	newins ${FILESDIR}/cvspserver.xinetd.d cvspserver || die "newins failed"

	dodoc BUGS COPYING* ChangeLog* DEVEL* FAQ HACKING \
		MINOR* NEWS PROJECTS README* TESTS TODO || \
			die "dodoc failed"
	insinto /usr/share/emacs/site-lisp
	doins cvs-format.el || die "doins failed"
}
