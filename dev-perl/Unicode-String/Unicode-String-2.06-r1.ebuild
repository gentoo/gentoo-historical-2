# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-String/Unicode-String-2.06-r1.ebuild,v 1.12 2003/02/13 11:21:48 vapier Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="A Unicode Perl Module"
SRC_URI="http://cpan.valueclick.com/modules/by-module/Unicode/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/Unicode/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc alpha"

DEPEND="${DEPEND}
	>=dev-perl/MIME-Base64-2.11"
