# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/slidentd/slidentd-1.0.0.ebuild,v 1.7 2005/09/25 10:45:55 vapier Exp $

DESCRIPTION="A secure, lightweight ident daemon"
HOMEPAGE="http://www.uncarved.com/slidentd/"
SRC_URI="http://www.uncarved.com/slidentd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc sparc x86"
IUSE=""

DEPEND="dev-libs/libowfat"
RDEPEND="${DEPEND}
	virtual/inetd"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "/^normal_cflags/s:=.*:=-DNDEBUG ${CFLAGS} -I/usr/include/libowfat:" \
		-e '/ALL=/s:stripobjects::' \
		-e '/ALL=/s:strip::' \
		Makefile || die
}

src_compile() {
	emake -j1 build_mode=normal || die
}

src_install () {
	make DESTDIR="${D}" install || die

	exeinto /var/lib/supervise/slidentd
	newexe "${FILESDIR}"/slidentd-run run
}

pkg_postinst() {
	einfo "You need to start your supervise service:"
	einfo '# ln -s /var/lib/supervise/slidentd /service/'
}
