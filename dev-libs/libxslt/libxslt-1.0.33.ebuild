# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxslt/libxslt-1.0.33.ebuild,v 1.3 2003/10/05 13:09:44 obz Exp $

inherit libtool gnome.org

IUSE="python"
DESCRIPTION="XSLT libraries and tools"
HOMEPAGE="http://www.xmlsoft.org/"
SLOT="0"
LICENSE="MIT"
KEYWORDS="ia64 x86 ~ppc ~sparc ~alpha ~hppa ~amd64"

DEPEND=">=dev-libs/libxml2-2.5.6
	python? ( dev-lang/python )"

src_compile() {
	elibtoolize

	econf `use_with python` || die

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
