# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxslt/libxslt-1.0.17-r1.ebuild,v 1.2 2002/07/11 06:30:21 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="XSLT libraries and tools"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"

RDEPEND="virtual/glibc
	 >=dev-libs/libxml2-2.4.17"

DEPEND="${RDEPEND}
	sys-devel/perl"

src_compile() {
	# Fix .la files of python site packages
	libtoolize --copy --force

	./configure --host=${CHOST} \
		    --prefix=/usr \
		    --mandir=/usr/share/man || die

	emake || die
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
