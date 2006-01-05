# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/timezone-data/timezone-data-2005r.ebuild,v 1.2 2006/01/05 19:01:15 gustavoz Exp $

inherit eutils

DESCRIPTION="Timezone data (/usr/share/zoneinfo) and utilities (tzselect/zic/zdump)"
HOMEPAGE="ftp://elsie.nci.nih.gov/pub/"
SRC_URI="ftp://elsie.nci.nih.gov/pub/tzdata${PV}.tar.gz
	ftp://elsie.nci.nih.gov/pub/tzcode${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 sparc ~x86"
IUSE=""

DEPEND=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cp Makefile{,.orig}
	epatch "${FILESDIR}"/${PN}-2005n-makefile.patch
}

src_install() {
	make install DESTDIR="${D}" || die
	rm -rf "${D}"/usr/share/zoneinfo-leaps
	dodoc README Theory
	dohtml *.htm *.jpg
}
