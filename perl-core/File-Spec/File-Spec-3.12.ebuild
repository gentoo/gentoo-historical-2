# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/File-Spec/File-Spec-3.12.ebuild,v 1.3 2006/01/15 01:40:08 vapier Exp $

MY_P="PathTools-${PV}"
S=${WORKDIR}/${MY_P}

myconf='INSTALLDIRS=vendor'
inherit perl-module

DESCRIPTION="Handling files and directories portably"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/K/KW/KWILLIAMS/${P}.readme"
SRC_URI="mirror://cpan/authors/id/K/KW/KWILLIAMS/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm hppa ia64 ~mips ~ppc ~ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="dev-perl/module-build"
