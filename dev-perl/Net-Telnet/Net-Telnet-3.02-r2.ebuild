# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Telnet/Net-Telnet-3.02-r2.ebuild,v 1.7 2002/08/14 04:32:33 murphy Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="A Telnet Perl Module"
SRC_URI="http://www.cpan.org/modules/by-module/Net/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Net/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="${DEPEND}
	>=dev-perl/libnet-1.0703"
