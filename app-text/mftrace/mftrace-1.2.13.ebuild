# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/mftrace/mftrace-1.2.13.ebuild,v 1.1 2008/01/13 13:30:20 aballier Exp $

inherit python multilib toolchain-funcs

DESCRIPTION="traces TeX fonts to PFA or PFB fonts (formerly pktrace)"
HOMEPAGE="http://lilypond.org/download/sources/mftrace/"
SRC_URI="http://lilypond.org/download/sources/mftrace/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
# SLOT 1 was used in pktrace ebuild
SLOT="1"
IUSE="truetype"

DEPEND=">=dev-lang/python-2.2.2
	|| ( media-gfx/potrace >=media-gfx/autotrace-0.30 )"

RDEPEND="${DEPEND}
	virtual/latex-base
	>=app-text/t1utils-1.25
	truetype? ( media-gfx/fontforge )"

src_compile() {
	python_version
	tc-export CC
	econf --datadir=/usr/$(get_libdir)/python${PYVER}/site-packages || \
	die "econf failed"
	emake CFLAGS="-Wall ${CFLAGS}" || die "emake failed"
}

src_install () {
	python_version
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README.txt ChangeLog
}
