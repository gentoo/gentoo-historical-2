# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PlRPC/PlRPC-0.2016-r1.ebuild,v 1.3 2002/12/09 04:21:10 manson Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="The Perl RPC Module"
SRC_URI="http://www.cpan.org/modules/by-module/RPC/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/RPC/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc alpha sparc "

DEPEND="${DEPEND}
	>=dev-perl/Storable-1.0.7
	>=dev-perl/Net-Daemon-0.34"
