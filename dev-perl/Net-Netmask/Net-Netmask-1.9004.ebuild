# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Netmask/Net-Netmask-1.9004.ebuild,v 1.6 2004/06/25 00:48:53 agriffis Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Parse, manipulate and lookup IP network blocks"
SRC_URI="http://search.cpan.org/CPAN/authors/id/M/MU/MUIR/modules/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/MUIR/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ~ppc sparc alpha mips"

mydoc="TODO"
