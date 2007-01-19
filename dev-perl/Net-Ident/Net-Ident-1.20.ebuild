# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Ident/Net-Ident-1.20.ebuild,v 1.14 2007/01/19 14:51:45 mcummings Exp $

inherit perl-module

DESCRIPTION="lookup the username on the remote end of a TCP/IP connection"
SRC_URI="mirror://cpan/authors/id/J/JP/JPC/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~jpc/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 hppa ia64 ~ppc ppc64 sparc x86"
IUSE=""

mydoc="TODO"


DEPEND="dev-lang/perl"
