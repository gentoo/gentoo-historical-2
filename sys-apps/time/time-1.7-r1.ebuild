# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/time/time-1.7-r1.ebuild,v 1.22 2004/11/08 19:29:29 vapier Exp $

inherit eutils

DESCRIPTION="displays info about resources used by a program"
HOMEPAGE="http://www.gnu.org/directory/time.html"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/time/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
	automake -a || die "automake"
	autoconf || die "autoconf"
	epatch ${FILESDIR}/${PV}-info-dir-entry.patch
}

src_install() {
	make install DESTDIR=${D} || die
	dodoc ChangeLog README AUTHORS NEWS
}
