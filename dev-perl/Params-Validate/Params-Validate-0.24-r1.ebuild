# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Params-Validate/Params-Validate-0.24-r1.ebuild,v 1.12 2005/03/12 11:03:50 corsair Exp $

inherit perl-module

DESCRIPTION="A module to provide a flexible system for validation method/function call parameters"
SRC_URI="http://www.perl.com/CPAN/modules/by-authors/id/D/DR/DROLSKY/${P}.tar.gz"
HOMEPAGE="http://www.perl.com/CPAN/modules/by-authors/id/D/DR/DROLSKY/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ppc ~alpha sparc"
IUSE=""

DEPEND="${DEPEND}"

mydoc="CREDITS UPGRADE"

src_install () {

	perl-module_src_install
	dohtml htdocs/*

}
