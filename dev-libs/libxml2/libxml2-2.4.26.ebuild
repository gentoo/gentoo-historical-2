# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxml2/libxml2-2.4.26.ebuild,v 1.3 2002/11/12 22:33:46 foser Exp $

inherit libtool gnome2

IUSE="zlib python readline"
S=${WORKDIR}/${P}
DESCRIPTION="Version 2 of the library to manipulate XML files"
HOMEPAGE="http://www.gnome.org/"

DEPEND="zlib? ( sys-libs/zlib )
	python? ( dev-lang/python )
	readline? ( sys-libs/readline )"
 
SLOT="2"
LICENSE="MIT"
KEYWORDS="x86 ~sparc ~sparc64 ~ppc ~alpha"

src_compile() {
	# Fix .la files of python site packages
	elibtoolize

	local myconf

	use zlib && myconf="--with-zlib" || myconf="--without-zlib"
	use python && myconf="${myconf} --with-python" \
		|| myconf="${myconf} --without-python" 
	use readline && myconf="${myconf} --with-readline" \
		|| myconf="${myconf} --without-readline"

	econf ${myconf}  || die
	emake || die
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
