# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Tty/IO-Tty-0.04-r1.ebuild,v 1.11 2006/08/05 04:46:42 mcummings Exp $

inherit perl-module

DESCRIPTION="IO::Tty and IO::Pty modules for Perl"
HOMEPAGE="http://search.cpan.org/~gbarr/${P}/"
SRC_URI="mirror://cpan/authors/id/G/GB/GBARR/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha"
IUSE=""

mymake="/usr"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
