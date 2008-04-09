# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/docbook2X/docbook2X-0.8.8-r1.ebuild,v 1.1 2008/04/09 09:27:21 pva Exp $

DESCRIPTION="Tools to convert docbook to man and info"
SRC_URI="mirror://sourceforge/docbook2x/${P}.tar.gz"
HOMEPAGE="http://docbook2x.sourceforge.net/"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""
LICENSE="MIT"

DEPEND=""

RDEPEND=">=dev-perl/XML-Writer-0.4
	>=dev-perl/XML-XSLT-0.31
	>=dev-perl/SGMLSpm-1.03
	dev-perl/XML-SAX
	dev-libs/libxslt"

src_compile() {
	econf \
		--with-xslt-processor=libxslt \
		--program-transform-name='s,\(docbook2.*\),\1.pl,' \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make "DESTDIR=${D}" install || die "install failed"

	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}

pkg_postinst() {
	elog "To avoid conflict with docbook-sgml-utils, which is much more widely used,"
	elog "all executables have been renamed to *.pl."
}
