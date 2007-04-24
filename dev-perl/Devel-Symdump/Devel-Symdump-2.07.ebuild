# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-Symdump/Devel-Symdump-2.07.ebuild,v 1.4 2007/04/24 08:45:08 kloeri Exp $

inherit versionator perl-module

MY_P="${PN}-$(delete_version_separator 2)"
S=${WORKDIR}/${MY_P}


DESCRIPTION="dump symbol names or the symbol table"
HOMEPAGE="http://search.cpan.org/~andk/"
SRC_URI="mirror://cpan/authors/id/A/AN/ANDK/${MY_P}.tar.gz"

SRC_TEST="do"
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc ~x86"
IUSE=""


DEPEND="dev-lang/perl"
