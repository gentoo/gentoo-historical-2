# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/AxKit/AxKit-1.6-r2.ebuild,v 1.1 2002/12/20 02:51:27 mcummings Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="The Apache AxKit Perl Module"
SRC_URI="http://axkit.org/download/${P}.tar.gz"
HOMEPAGE="http://axkit.org/"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 alpha sparc  ~ppc"

newdepend ">=dev-perl/libapreq-1.0 \
	>=dev-perl/Compress-Zlib-1.10 \
	>=dev-perl/Error-0.13 \
	gnome? ( >=dev-perl/HTTP-GHTTP-1.06 ) : dev-perl/libwww-perl-5.64-r1 \
	>=dev-perl/Storable-1.0.7 \
	>=dev-perl/XML-XPath-1.04 \
	>=dev-perl/XML-LibXML-1.31 \
	>=dev-perl/XML-LibXSLT-1.31 \
	>=dev-perl/XML-Sablot-0.50 \
	>=dev-perl/Digest-MD5-2.09
	<dev-perl/mod_perl-1.99"

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
