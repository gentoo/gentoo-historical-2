# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libtrash/libtrash-2.2.ebuild,v 1.4 2004/06/24 23:06:55 agriffis Exp $

inherit eutils gcc

DESCRIPTION="provides a trash can by intercepting certain calls to glibc"
HOMEPAGE="http://www.m-arriaga.net/software/libtrash/"
SRC_URI="http://www.m-arriaga.net/software/libtrash/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

DEPEND=">=virtual/glibc-2.3.2
	dev-lang/perl"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	make CC="$(gcc-getCC)" CFLAGS="${CFLAGS}" || die
}

src_install() {
	dodir /etc /usr/lib
	make DESTDIR=${D} install || die

	dosbin cleanTrash/ct2.pl
	exeinto /etc/cron.daily
	doexe ${FILESDIR}/cleanTrash.cron

	dodoc CHANGE.LOG README libtrash.conf TODO

	docinto cleanTrash
	dodoc cleanTrash/README cleanTrash/cleanTrash
}

pkg_postinst() {
	einfo
	einfo "To use this you have to put the trash library as one"
	einfo "of the variables in LD_PRELOAD."
	einfo "Example in bash:"
	einfo "export LD_PRELOAD=/usr/lib/libtrash.so"
	einfo
	einfo "Also, see /etc/cron.daily/cleanTrash.cron if you'd like to turn on"
	einfo "daily trash cleanup."
	einfo
}
