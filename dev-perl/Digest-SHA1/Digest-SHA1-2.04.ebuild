# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Digest-SHA1/Digest-SHA1-2.04.ebuild,v 1.2 2003/11/09 14:44:21 mcummings Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION=" NIST SHA message digest algorithm"
SRC_URI="http://www.perl.com/CPAN/authors/id/GAAS/${P}.tar.gz"
HOMEPAGE="http://cpan.pair.com/modules/by-category/14_Security_and_Encryption/Digest/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ~amd64 ~ppc ~sparc ~alpha"
