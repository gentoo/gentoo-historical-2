# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxml2/libxml2-2.4.23.ebuild,v 1.4 2002/08/02 03:24:39 gerk Exp $

inherit libtool

S=${WORKDIR}/${P}
DESCRIPTION="libxml2"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/libxml/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"

DEPEND=">=sys-libs/ncurses-5.2
	>=sys-libs/readline-4.1
	>=sys-libs/zlib-1.1.4" 

SLOT="2"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 ppc"

src_compile() {
	# Fix .la files of python site packages
	elibtoolize

	econf --with-zlib  || die
	make || die
}

src_install() {
	make \
		DESTDIR=${D} \
		DOCS_DIR=/usr/share/doc/${PF}/python \
		EXAMPLE_DIR=/usr/share/doc/${PF}/python/example \
		BASE_DIR=/usr/share/doc \
		DOC_MODULE=${PF} \
		EXAMPLES_DIR=/usr/share/doc/${PF}/example \
		TARGET_DIR=/usr/share/doc/${PF}/html \
		install || die
	
	dodoc AUTHORS COPYING* ChangeLog NEWS README
}
