# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Inspector/Class-Inspector-1.ebuild,v 1.5 2004/05/24 00:39:18 kloeri Exp $

inherit perl-module

DESCRIPTION="Provides information about Classes"
HOMEPAGE="http://search.cpan.org/author/ADAMK/${P}/"
SRC_URI="http://search.cpan.org/CPAN/authors/id/A/AD/ADAMK/${P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc alpha hppa amd64 ~mips"

DEPEND="dev-perl/Test-Simple
	dev-perl/Class-ISA
	dev-perl/File-Spec"
