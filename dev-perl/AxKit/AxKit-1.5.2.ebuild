# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/AxKit/AxKit-1.5.2.ebuild,v 1.3 2002/07/11 06:30:21 drobbins Exp $

S=${WORKDIR}/${PN}-1.52
DESCRIPTION="The Apache AxKit Perl Module"
SRC_URI="http://xml.sergeant.org/download/${P}.tar.gz"
HOMEPAGE="http://xml.sergeant.org/"

DEPEND=">=sys-devel/perl-5
	>=dev-perl/libapreq-0.31
	>=dev-perl/Compress-Zlib-1.10
	>=dev-perl/Error-0.13
	>=dev-perl/HTTP-GHTTP-1.06
	>=dev-perl/Storable-1.0.7
	>=dev-perl/XML-XPath-1.04
	>=dev-perl/XML-XPath-1.04
	>=dev-perl/XML-LibXML-1.31
	>=dev-perl/XML-LibXSLT-1.31
	>=dev-perl/libapreq-1.0
	>=dev-perl/XML-Sablot-0.50"

src_unpack() {
  unpack ${A}
  cd ${S}
  cp Makefile.PL Makefile.PL.orig
  sed -e "s:0\.31_03:0.31:" Makefile.PL.orig > Makefile.PL
}

src_compile() {

    perl Makefile.PL
	emake || die "emake failed"
    make test || die "make test failed"
}

src_install () {

    make PREFIX=${D}/usr INSTALLMAN3DIR=${D}/usr/share/man/man3 install || die "install failed"
    diropts -o nobody -g nogroup
    dodir /var/cache/axkit
    dodir /home/httpd/htdocs/xslt
    insinto /etc/apache
    doins ${FILESDIR}/httpd.axkit
    dodoc ChangeLog MANIFEST README* TODO

}



