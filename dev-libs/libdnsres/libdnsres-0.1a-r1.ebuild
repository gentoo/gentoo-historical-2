# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libdnsres/libdnsres-0.1a-r1.ebuild,v 1.7 2006/10/26 09:16:52 pva Exp $

WANT_AUTOMAKE=1.8
inherit autotools

DESCRIPTION="A non-blocking DNS resolver library"
HOMEPAGE="http://www.monkey.org/~provos/libdnsres/"
SRC_URI="http://www.monkey.org/~provos/${P}.tar.gz"

LICENSE="|| ( as-is BSD )"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE=""

DEPEND="dev-libs/libevent"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "s:LIBOBJS:LTLIBOBJS:" \
	-e "s:CFLAGS:AM_CFLAGS:" Makefile.am || die "sed of Makefile.am failed"
	# See Makefile.in for automake version upstream dev uses.
	eautomake || die "automake failed"
}

src_compile() {
	econf || die "econf failed"
	emake -j1 || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README
}
