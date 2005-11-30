# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/mftrace/mftrace-1.1.16.ebuild,v 1.1 2005/09/23 14:55:58 matsuu Exp $

IUSE="truetype"
inherit python multilib

DESCRIPTION="traces TeX fonts to PFA or PFB fonts (formerly pktrace)"
HOMEPAGE="http://www.xs4all.nl/~hanwen/mftrace/"
SRC_URI="http://www.xs4all.nl/~hanwen/mftrace/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
# SLOT 1 was used in pktrace ebuild
SLOT="1"

DEPEND=">=dev-lang/python-2.2.2"

RDEPEND="${DEPEND}
	virtual/tetex
	>=app-text/t1utils-1.25
	|| ( >=media-gfx/autotrace-0.30 media-gfx/potrace )
	truetype? ( || ( media-gfx/fontforge >=media-gfx/pfaedit-030512 ) )"

src_compile() {
	python_version
	econf --datadir=/usr/$(get_libdir)/python${PYVER}/site-packages || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	python_version
	make \
		prefix=${D}/usr \
		datadir=${D}/usr/$(get_libdir)/python${PYVER}/site-packages/mftrace \
		mandir=${D}/usr/share/man \
		install || die "make install failed"

	dodoc README.txt ChangeLog
}
