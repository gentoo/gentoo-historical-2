# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-SAX/XML-SAX-0.10-r1.ebuild,v 1.10 2002/10/17 16:43:15 bjb Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Perl module for using and building Perl SAX2 XML parsers, filters, and drivers"
SRC_URI="http://cpan.valueclick.com/modules/by-category/11_String_Lang_Text_Proc/XML/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-category/11_String_Lang_Text_Proc/XML/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc sparc64 alpha"

DEPEND="${DEPEND}
	>=dev-perl/XML-NamespaceSupport-1.04
	>=dev-libs/libxml2-2.4.1"

export PERL5LIB=`perl -e 'print map { ":$ENV{D}/$_" } @INC'`

src_compile() {
	echo n |perl Makefile.PL ${myconf} \
	        PREFIX=${D}/usr 
	make || test
}
