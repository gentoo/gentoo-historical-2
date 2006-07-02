# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ExtUtils-CBuilder/ExtUtils-CBuilder-0.18.ebuild,v 1.7 2006/07/02 20:07:50 vapier Exp $

inherit perl-module

DESCRIPTION="Compile and link C code for Perl modules"
HOMEPAGE="http://search.cpan.org/~kwilliams/${P}/"
SRC_URI="mirror://cpan/authors/id/K/KW/KWILLIAMS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ~ppc ~ppc64 s390 sh sparc ~x86 ~x86-fbsd"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/module-build"
