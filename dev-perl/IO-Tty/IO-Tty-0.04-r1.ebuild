# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Tty/IO-Tty-0.04-r1.ebuild,v 1.4 2003/02/13 11:10:46 vapier Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="IO::Tty and IO::Pty modules for Perl"
HOMEPAGE="http://cpan.valueclick.com/authors/id/G/GB/GBARR/${P}.readme"
SRC_URI="http://cpan.valueclick.com/authors/id/G/GB/GBARR/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc alpha"

mymake="/usr"
