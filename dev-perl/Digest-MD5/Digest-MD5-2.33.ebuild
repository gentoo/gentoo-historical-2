# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Digest-MD5/Digest-MD5-2.33.ebuild,v 1.12 2004/07/14 17:25:08 agriffis Exp $

inherit perl-module

DESCRIPTION="MD5 message digest algorithm"
HOMEPAGE="http://http://www.cpan.org/modules/by-authors/id/G/GA/GAAS/${P}.readme"
SRC_URI="http://www.cpan.org/modules/by-authors/id/G/GA/GAAS/${P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha arm hppa amd64 ia64 s390"
IUSE=""

DEPEND="dev-perl/digest-base"

mydoc="rfc*.txt"
