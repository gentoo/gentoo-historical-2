# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gperf/gperf-2.7.2.ebuild,v 1.4 2002/08/16 04:04:41 murphy Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A perfect hash function generator."
SRC_URI="ftp://ftp.gnu.org/pub/gnu/gperf/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/gperf/gperf.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"

DEPEND="virtual/glibc"

src_install () {
	make DESTDIR=${D} install || die
}
