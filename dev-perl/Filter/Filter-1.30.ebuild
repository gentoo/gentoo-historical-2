# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Filter/Filter-1.30.ebuild,v 1.2 2004/06/25 00:30:43 agriffis Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Interface for creation of Perl Filters"
HOMEPAGE="http://cpan.valueclick.com/authors/id/P/PM/PMQS/${P}.readme"
SRC_URI="http://cpan.valueclick.com/authors/id/P/PM/PMQS/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha ~hppa ~mips ~s390"

mymake="/usr"
