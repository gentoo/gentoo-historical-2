# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxslt/libxslt-1.1.8.ebuild,v 1.1 2004/07/13 11:23:10 obz Exp $

inherit libtool gnome.org
use python && inherit python

DESCRIPTION="XSLT libraries and tools"
HOMEPAGE="http://www.xmlsoft.org/"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha ~arm ~hppa ~amd64 ~ia64 ~s390 ~ppc64"
IUSE="python"

DEPEND=">=dev-libs/libxml2-2.6.8
	python? ( dev-lang/python )"

src_compile() {
	elibtoolize
	econf `use_with python` || die "configure failed"
	emake || die "make failed"
}

src_install() {

	make DESTDIR=${D} install
	dodoc AUTHORS ChangeLog README NEWS TODO

}
