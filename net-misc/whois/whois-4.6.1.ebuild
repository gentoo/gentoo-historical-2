# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/whois/whois-4.6.1.ebuild,v 1.3 2003/02/24 19:42:05 dragon Exp $

IUSE="nls"
MY_P=${P/-/_}
DESCRIPTION="improved Whois Client"
SRC_URI="http://www.linux.it/~md/software/${MY_P}.tar.gz"
HOMEPAGE="http://www.linux.it/~md/software/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc mips"

DEPEND=">=sys-devel/perl-5"
RDEPEND="virtual/glibc"

src_unpack() {

	unpack ${A}
	cd ${S}
	cp Makefile Makefile.orig
	sed \
		-e "s/-O2/$CFLAGS/" \
		Makefile.orig > Makefile

	use nls && ( \
		cd po
		cp Makefile Makefile.orig
		sed -e "s:/usr/bin/install:/bin/install:" \
			Makefile.orig > Makefile
	) || ( \
		cp Makefile Makefile.orig
		sed "s:cd po.*::" \
			Makefile.orig > Makefile
	)

}

src_compile() {

	make || die
	make mkpasswd || die

}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1
	use nls && dodir /usr/share/locale
	make BASEDIR=${D} prefix=/usr mandir=/usr/share/man install || die
	
	dobin mkpasswd
	doman mkpasswd.1
	dodoc README TODO debian/changelog debian/copyright

}
