# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mon/Mon-0.11-r1.ebuild,v 1.7 2002/08/01 22:23:06 cselkirk Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="A Monitor Perl Module"
SRC_URI="http://www.cpan.org/modules/by-module/Mon/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Mon/${P}.readme"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

DEPEND="${DEPEND}
	>=net-analyzer/fping-2.2_beta1
	>=dev-perl/Convert-BER-1.31
	>=dev-perl/Net-Telnet-3.02"

mydoc="COPYING COPYRIGHT VERSION"
