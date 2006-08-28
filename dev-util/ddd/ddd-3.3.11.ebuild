# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ddd/ddd-3.3.11.ebuild,v 1.12 2006/08/28 18:56:22 agriffis Exp $

inherit eutils

DESCRIPTION="graphical front-end for command-line debuggers"
HOMEPAGE="http://www.gnu.org/software/ddd"
SRC_URI="mirror://sourceforge/ddd/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2 LGPL-2.1 FDL-1.1"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="|| ( ( x11-libs/libXaw
			x11-libs/libXp
		)
		virtual/x11
	)
	>=sys-devel/gcc-3
	>=sys-devel/gdb-6.4
	virtual/motif"
RDEPEND="${DEPEND}
	sci-visualization/gnuplot"

RESTRICT="test"

src_compile() {
	CXXFLAGS="${CXXFLAGS}"
	econf || die
	emake || die
}

src_install() {
	dodir /usr/lib
	# If using internal libiberty.a, need to pass
	# $tooldir to 'make install', else we get
	# sandbox errors ... bug #4614.
	# <azarah@gentoo.org> 05 Dec 2002
	einstall tooldir=${D}/usr || die

	# This one is from binutils
	[ -f ${D}/usr/lib/libiberty.a ] && rm -f ${D}/usr/lib/libiberty.a
	# Remove empty dir ...
	rmdir ${D}/usr/lib || :

	mv ${S}/doc/README ${S}/doc/README-DOC
	dodoc ANNOUNCE AUTHORS BUGS COPYING* CREDITS INSTALL NEWS* NICKNAMES \
		OPENBUGS PROBLEMS README* TIPS TODO

	mv ${S}/doc/* ${D}/usr/share/doc/${PF}
}
