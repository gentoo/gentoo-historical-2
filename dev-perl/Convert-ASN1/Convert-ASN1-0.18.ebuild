# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Convert-ASN1/Convert-ASN1-0.18.ebuild,v 1.11 2006/08/05 01:33:53 mcummings Exp $

inherit perl-module

DESCRIPTION="Standard en/decode of ASN.1 structures"
HOMEPAGE="http://cpan.pair.com/modules/by-module/Convert/${P}.readme"
SRC_URI="http://cpan.pair.com/modules/by-module/Convert/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE=""

SRC_TEST="do"
DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
