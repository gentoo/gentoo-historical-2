# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxslt/libxslt-1.0.20.ebuild,v 1.2 2002/09/16 00:47:44 murphy Exp $

inherit libtool

S=${WORKDIR}/${P}
DESCRIPTION="XSLT libraries and tools"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 sparc sparc64"

RDEPEND=">=dev-libs/libxml2-2.4.24"

DEPEND="${RDEPEND}
	sys-devel/perl"

src_compile() {
	# Fix .la files of python site packages
	elibtoolize

	econf || die
	#libxslt-1.0.19 didn't like parallel make; test a good deal before re-enabling
	#(drobbins, 24 Jul 2002)
	patch -p0 < ${FILESDIR}/Makefile-py.patch
	make || die
}

src_install() {                               
	make DESTDIR=${D} \
		DOCS_DIR=/usr/share/doc/${PF}/python \
		EXAMPLE_DIR=/usr/share/doc/${PF}/python/example \
		BASE_DIR=/usr/share/doc \
		DOC_MODULE=${PF} \
		EXAMPLES_DIR=/usr/share/doc/${PF}/example \
		TARGET_DIR=/usr/share/doc/${PF}/html \
		install || die

	dodoc AUTHORS COPYING* ChangeLog README NEWS TODO
}
