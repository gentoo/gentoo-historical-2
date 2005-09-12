# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/pwgen/pwgen-2.04.ebuild,v 1.3 2005/09/12 14:29:29 ferdy Exp $

inherit eutils

DESCRIPTION="Password Generator"
HOMEPAGE="http://sourceforge.net/projects/pwgen/"
SRC_URI="mirror://sourceforge/pwgen/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~sparc ~x86"
IUSE="livecd"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e 's:$(prefix)/man/man1:$(mandir)/man1:g' Makefile.in
}

src_compile() {
	econf --sysconfdir=/etc/pwgen || die "econf failed"
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	use livecd && exeinto /etc/init.d && newexe ${FILESDIR}/pwgen.rc pwgen
}
