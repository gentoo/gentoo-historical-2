# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/bc/bc-1.06.95.ebuild,v 1.10 2008/06/09 15:16:18 jer Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Handy console-based calculator utility"
HOMEPAGE="http://www.gnu.org/software/bc/bc.html"
SRC_URI="ftp://alpha.gnu.org/gnu/bc/${P}.tar.bz2
	mirror://gnu/bc/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="libedit readline static"

RDEPEND="readline? ( >=sys-libs/readline-4.1 >=sys-libs/ncurses-5.2 )
	libedit? ( || ( sys-freebsd/freebsd-lib dev-libs/libedit ) )"
DEPEND="${RDEPEND}
	sys-devel/flex"

src_compile() {
	local myconf
	if use readline ; then
		myconf="--with-readline --without-libedit"
	elif use libedit ; then
		myconf="--without-readline --with-libedit"
	else
		myconf="--without-readline --without-libedit"
	fi
	use static && append-ldflags -static
	econf ${myconf} || die
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS FAQ NEWS README ChangeLog
}
