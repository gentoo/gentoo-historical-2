# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/class-returnvalue/class-returnvalue-0.52.ebuild,v 1.5 2004/07/14 16:55:09 agriffis Exp $

inherit perl-module

MY_P=Class-ReturnValue-${PV}

DESCRIPTION="A return-value object that lets you treat it as as a boolean, array or object"
HOMEPAGE="http://www.cpan.org/authors/id/J/JE/JESSE/"
SRC_URI="http://www.cpan.org/authors/id/J/JE/JESSE/${MY_P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc alpha hppa ~amd64"
IUSE=""

DEPEND="dev-perl/Devel-StackTrace
	dev-perl/Test-Inline"

S=${WORKDIR}/${MY_P}
