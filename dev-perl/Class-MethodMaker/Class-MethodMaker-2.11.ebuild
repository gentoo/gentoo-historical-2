# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-MethodMaker/Class-MethodMaker-2.11.ebuild,v 1.4 2008/11/04 10:20:25 vapier Exp $

inherit perl-module eutils

DESCRIPTION="Perl module for Class::MethodMaker"
HOMEPAGE="http://search.cpan.org/~schwigon"
SRC_URI="mirror://cpan/authors/id/S/SC/SCHWIGON/class-methodmaker/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ia64 m68k ~mips ~ppc ~ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

SRC_TEST="do"
PREFER_BUILDPL="no"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
	>=dev-perl/module-build-0.28"
