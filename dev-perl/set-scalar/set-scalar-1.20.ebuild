# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/set-scalar/set-scalar-1.20.ebuild,v 1.1 2006/01/13 16:29:06 mcummings Exp $

inherit perl-module
MY_P=Set-Scalar-${PV}
S=${WORKDIR}/${MY_P}
IUSE=""

DESCRIPTION="Scalar set operations"
SRC_URI="mirror://cpan/authors/id/J/JH/JHI/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/JHI/Set-Scalar-1.17/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha ~ia64 ~ppc ~s390 ~sparc ~x86"

SRC_TEST="do"
