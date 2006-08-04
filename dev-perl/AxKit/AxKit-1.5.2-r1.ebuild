# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/AxKit/AxKit-1.5.2-r1.ebuild,v 1.26 2006/08/04 22:34:18 mcummings Exp $

inherit perl-module

S=${WORKDIR}/${PN}-1.52
DESCRIPTION="The Apache AxKit Perl Module"
SRC_URI="http://axkit.org/download/${P}.tar.gz"
HOMEPAGE="http://axkit.org/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 ppc sparc alpha"
IUSE=""

DEPEND=">=www-apache/libapreq-0.31
	>=dev-perl/Compress-Zlib-1.10
	>=dev-perl/Error-0.13
	>=dev-perl/HTTP-GHTTP-1.06
	>=virtual/perl-Storable-1.0.7
	>=dev-perl/XML-XPath-1.04
	>=dev-perl/XML-LibXML-1.31
	>=dev-perl/XML-LibXSLT-1.31
	>=www-apache/libapreq-1.0
	>=dev-perl/XML-Sablot-0.50
	dev-lang/perl"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp Makefile.PL Makefile.PL.orig
	sed -e "s:0\.31_03:0.31:" Makefile.PL.orig > Makefile.PL
}

src_install() {
	perl-module_src_install

	diropts -o nobody -g nogroup
	dodir /var/cache/axkit
	dodir /home/httpd/htdocs/xslt
	insinto /etc/apache
	doins ${FILESDIR}/httpd.axkit
}
