# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Filter/Filter-1.29.ebuild,v 1.4 2003/07/03 21:41:54 gmsoft Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Interface for creation of Perl Filters"
HOMEPAGE="http://cpan.valueclick.com/authors/id/P/PM/PMQS/${P}.readme"
SRC_URI="http://cpan.valueclick.com/authors/id/P/PM/PMQS/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 ~ppc ~sparc alpha hppa"

mymake="/usr"
