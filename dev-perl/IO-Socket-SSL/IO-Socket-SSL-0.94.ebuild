# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Socket-SSL/IO-Socket-SSL-0.94.ebuild,v 1.5 2004/01/07 21:42:45 agriffis Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Nearly transparent SSL encapsulation for IO::Socket::INET"
SRC_URI="http://cpan.valueclick.com/authors/id/B/BE/BEHROOZI/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/BEHROOZI/${P}/README"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~x86 ~amd64 ~sparc ppc alpha ia64"

DEPEND="${DEPEND} dev-perl/Net-SSLeay"
