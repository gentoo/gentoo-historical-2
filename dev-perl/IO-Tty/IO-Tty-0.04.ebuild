# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Tty/IO-Tty-0.04.ebuild,v 1.14 2004/06/25 00:40:28 agriffis Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="IO::Tty and IO::Pty modules for Perl"
HOMEPAGE="http://cpan.valueclick.com/authors/id/G/GB/GBARR/${P}.readme"
SRC_URI="http://cpan.valueclick.com/authors/id/G/GB/GBARR/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha"

mymake="/usr"
