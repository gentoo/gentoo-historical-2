# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/regexp-common/regexp-common-2.113.ebuild,v 1.9 2005/04/29 19:37:18 mcummings Exp $

inherit perl-module

MY_P=Regexp-Common-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Provide commonly requested regular expressions"
HOMEPAGE="http://www.cpan.org/authors/id/A/AB/ABIGAIL/"
SRC_URI="mirror://cpan/authors/id/A/AB/ABIGAIL/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="x86 ~ppc sparc alpha hppa amd64"
IUSE=""
