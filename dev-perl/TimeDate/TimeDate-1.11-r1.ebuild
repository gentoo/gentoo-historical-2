# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/TimeDate/TimeDate-1.11-r1.ebuild,v 1.7 2002/08/14 04:32:34 murphy Exp $

inherit perl-module

DESCRIPTION="A Date/Time Parsing Perl Module"
HOMEPAGE="http://www.cpan.org/modules/by-module/Date/${P}.readme"
SRC_URI="http://www.cpan.org/modules/by-module/Date/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc sparc64"

mymake="/usr"
