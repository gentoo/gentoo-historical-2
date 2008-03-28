# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/crypt-dsa/crypt-dsa-0.14.ebuild,v 1.7 2008/03/28 10:19:23 jer Exp $

inherit perl-module

MY_P=Crypt-DSA-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="DSA Signatures and Key Generation"
HOMEPAGE="http://search.cpan.org/CPAN/authors/id/B/BT/BTROTT/${MY_P}.readme"
SRC_URI="mirror://cpan/authors/id/B/BT/BTROTT/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~mips ~ppc sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/data-buffer
	dev-perl/math-pari
	dev-perl/crypt-random
	dev-perl/Digest-SHA1
	dev-perl/convert-pem
	dev-lang/perl"
