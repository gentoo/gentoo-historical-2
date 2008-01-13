# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GnuPG-Interface/GnuPG-Interface-0.36.ebuild,v 1.4 2008/01/13 21:29:33 dertobi123 Exp $

inherit perl-module

DESCRIPTION=" GnuPG::Interface is a Perl module interface to interacting with GnuPG."
HOMEPAGE="http://search.cpan.org/~jesse/"
SRC_URI="mirror://cpan/authors/id/J/JE/JESSE/${P}.tar.gz"
LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc sparc x86"
IUSE=""
DEPEND=">=app-crypt/gnupg-1.2.1-r1
	>=dev-perl/Class-MethodMaker-1.11
	dev-lang/perl"

SRC_TEST="do"
