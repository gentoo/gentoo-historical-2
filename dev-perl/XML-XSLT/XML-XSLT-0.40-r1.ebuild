# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-XSLT/XML-XSLT-0.40-r1.ebuild,v 1.3 2002/12/15 10:44:17 bjb Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="A Perl module to parse XSL Transformational sheets"
SRC_URI="http://cpan.valueclick.com/modules/by-category/11_String_Lang_Text_Proc/XML/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-category/11_String_Lang_Text_Proc/XML/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc alpha"

DEPEND="${DEPEND}
	>=dev-perl/XML-Parser-2.29
	>=dev-perl/XML-DOM-1.25
	>=dev-perl/libwww-perl-5.48"
