# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-XQL/XML-XQL-0.67-r1.ebuild,v 1.8 2004/06/25 01:15:04 agriffis Exp $

inherit perl-module

MY_P="${P/_/}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="A Perl module that allows you to perform XQL queries on XML trees"
HOMEPAGE="http://cpan.org/modules/by-module/XML/${MY_P}.readme"
SRC_URI="http://cpan.org/modules/by-module/XML/${MY_P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86 amd64 sparc ~ppc ~alpha"

DEPEND=">=dev-perl/libxml-perl-0.07-r1
	>=dev-perl/XML-DOM-1.39-r1
	>=dev-perl/Parse-Yapp-1.05
	>=dev-perl/DateManip-5.40-r1"
