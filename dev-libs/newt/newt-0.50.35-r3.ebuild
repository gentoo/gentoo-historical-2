# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/newt/newt-0.50.35-r3.ebuild,v 1.1 2004/05/13 03:34:27 robbat2 Exp $

inherit python

S=${WORKDIR}/${P}
DESCRIPTION="redhat's newt windowing toolkit development files"
SRC_URI="http://koto.mynetix.de/gentoo/${P}.tar.gz"
HOMEPAGE="http://www.redhat.com"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~hppa ~amd64 ~alpha"

DEPEND=">=sys-libs/slang-1.4
	>=dev-libs/popt-1.6
	dev-lang/python"

RDEPEND=""

src_compile() {
	python_version
	export RPM_OPT_FLAGS="${CFLAGS}"
	econf || die
	make PYTHONVERS=python${PYVER} || die "make failure"
}

src_install () {
	make prefix=${D}/usr PYTHONVERS=python${PYVER} install || die "make install failed"
	dodoc CHANGES COPYING peanuts.py popcorn.py tutorial.sgml
	dosym libnewt.so.${PV} /usr/lib/libnewt.so.0.50
}
