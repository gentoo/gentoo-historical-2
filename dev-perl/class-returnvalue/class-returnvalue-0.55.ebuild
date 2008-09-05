# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/class-returnvalue/class-returnvalue-0.55.ebuild,v 1.2 2008/09/05 17:32:39 armin76 Exp $

inherit perl-module

MY_P=Class-ReturnValue-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A return-value object that lets you treat it as as a boolean, array or object"
HOMEPAGE="http://www.cpan.org/authors/id/J/JE/JESSE/"
SRC_URI="mirror://cpan/authors/id/J/JE/JESSE/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ia64 ~ppc sparc x86"
IUSE=""

DEPEND="dev-perl/Devel-StackTrace
	dev-lang/perl"

SRC_TEST="do"
