# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/PodParser/PodParser-1.35.ebuild,v 1.11 2008/03/28 06:58:25 jer Exp $

inherit perl-module

MY_P=Pod-Parser-${PV}

DESCRIPTION="Base class for creating POD filters and translators"
HOMEPAGE="http://search.cpan.org/~marekr/"
SRC_URI="mirror://cpan/authors/id/M/MA/MAREKR/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl"

S=${WORKDIR}/${MY_P}

SRC_TEST="do"
