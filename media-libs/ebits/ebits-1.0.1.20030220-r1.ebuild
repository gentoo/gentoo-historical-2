# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ebits/ebits-1.0.1.20030220-r1.ebuild,v 1.1 2003/03/20 13:59:36 vladimir Exp $

DESCRIPTION="provides layout functionality for graphical elements like window borders"
HOMEPAGE="http://www.enlightenment.org/pages/ebits.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	http://wh0rd.tk/gentoo/distfiles/${P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha ~sparc ~hppa ~mips ~arm"
IUSE=""

DEPEND="virtual/glibc
	sys-devel/gcc
	>=x11-libs/evas-1.0.0.2003*"

S=${WORKDIR}/${PN}

src_compile() {
	cp autogen.sh{,.old}
	sed -e 's:.*configure.*::' autogen.sh.old > autogen.sh
	env WANT_AUTOCONF_2_5=1 ./autogen.sh || die "could not autogen"

	econf --with-gnu-ld || die
	emake || die
}

src_install() {
	make install DESTDIR=${D} || die
	find ${D} -name CVS -type d -exec rm -rf '{}' \;
	dodoc AUTHORS ChangeLog README
	dohtml -r doc
}
