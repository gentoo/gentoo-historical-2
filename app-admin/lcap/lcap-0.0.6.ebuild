# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/lcap/lcap-0.0.6.ebuild,v 1.4 2003/09/20 19:56:29 aliz Exp $

DESCRIPTION="kernel capability remover"

# The normal homepage of the program was not reachable by the time
# this ebuild was written
HOMEPAGE="http://packages.debian.org/unstable/admin/lcap.html"

# same for the sources
SRC_URI="mirror://debian/pool/main/l/lcap/${P/-/_}.orig.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="x86"

IUSE="lids"

DEPEND="virtual/os-headers
		virtual/glibc"
RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}
	use lids || (sed < Makefile > Makefile.tmp -e "s:LIDS =:#\0:" && \
				mv Makefile.tmp Makefile)
}

src_compile() {
	emake || die
}

src_install() {
	exeinto /usr/sbin
	doexe lcap
	doman lcap.8
	dodoc README
}
