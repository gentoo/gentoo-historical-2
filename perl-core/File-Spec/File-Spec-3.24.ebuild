# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/File-Spec/File-Spec-3.24.ebuild,v 1.5 2007/03/03 11:28:34 mcummings Exp $

inherit perl-module

MY_P="PathTools-${PV}"

DESCRIPTION="Handling files and directories portably"
HOMEPAGE="http://search.cpan.org/~kwilliams/"
SRC_URI="mirror://cpan/authors/id/K/KW/KWILLIAMS/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 m68k ~mips ~ppc ~ppc64 s390 sh sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/ExtUtils-CBuilder"
DEPEND="${RDEPEND}
	dev-perl/module-build"

S=${WORKDIR}/${MY_P}

myconf='INSTALLDIRS=vendor'
