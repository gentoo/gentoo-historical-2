# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Math-BigInt/Math-BigInt-1.77-r1.ebuild,v 1.3 2006/06/12 17:05:47 mcummings Exp $

inherit perl-module eutils

DESCRIPTION="Arbitrary size floating point math package"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/T/TE/TELS/math/${P}.readme"
SRC_URI="mirror://cpan/authors/id/T/TE/TELS/math/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~s390 ~sh sparc ~x86"
IUSE=""

DEPEND=">=virtual/perl-Scalar-List-Utils-1.14"

SRC_TEST="do"

src_unpack() {
	unpack ${A}
	 has_version 'dev-perl/yaml' && epatch ${FILESDIR}/yaml-node-makefile.patch
}
