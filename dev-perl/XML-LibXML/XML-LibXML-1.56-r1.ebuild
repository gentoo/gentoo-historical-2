# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-LibXML/XML-LibXML-1.56-r1.ebuild,v 1.4 2004/06/25 01:11:36 agriffis Exp $

inherit perl-module

DESCRIPTION="A Perl module to parse XSL Transformational sheets using gnome's libXSLT"
SRC_URI="http://cpan.org/modules/by-module/XML/${P}.tar.gz"
HOMEPAGE="http://cpan.org/modules/by-module/XML/${P}.readme"
IUSE=""
SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ~amd64 alpha ~ppc sparc"

DEPEND=">=dev-perl/XML-SAX-0.12
	dev-perl/XML-LibXML-Common
	>=dev-libs/libxml2-2.4.1
	>=dev-perl/XML-NamespaceSupport-1.07"

export PERL5LIB=`perl -e 'print map { ":$ENV{D}/$_" } @INC'`
mytargets="pure_install doc_install"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/${P}-dupextern.patch || die "dupextern patch failed"
}

pkg_postinst() {

	perl-module_pkg_postinst

	perl -MXML::SAX \
		-e "XML::SAX->add_parser(q(XML::LibXML::SAX::Parser))->save_parsers()"

}
