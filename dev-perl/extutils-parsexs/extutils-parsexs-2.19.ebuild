# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/extutils-parsexs/extutils-parsexs-2.19.ebuild,v 1.3 2008/11/04 10:20:27 vapier Exp $

MODULE_AUTHOR=KWILLIAMS

inherit perl-module

MY_P=ExtUtils-ParseXS-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Converts Perl XS code into C code"
SRC_URI="mirror://cpan/authors/id/K/KW/KWILLIAMS/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ia64 m68k ~mips ~ppc ~ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
	dev-perl/ExtUtils-CBuilder
	dev-perl/module-build"

SRC_TEST="do"
