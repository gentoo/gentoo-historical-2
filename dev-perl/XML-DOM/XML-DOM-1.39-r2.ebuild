# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-DOM/XML-DOM-1.39-r2.ebuild,v 1.2 2002/12/09 04:21:11 manson Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="A Perl module for an DOM Level 1 compliant interface"
SRC_URI="http://cpan.valueclick.com/modules/by-category/11_String_Lang_Text_Proc/XML/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-category/11_String_Lang_Text_Proc/XML/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc  alpha"

DEPEND="${DEPEND}
	dev-perl/XML-RegExp"
