# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-DBI/Class-DBI-3.0.13.ebuild,v 1.5 2006/01/30 17:29:59 superlag Exp $

inherit perl-module

MY_PV="v${PV}"
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Simple Database Abstraction"
HOMEPAGE="http://search.cpan.org/~tmtm/${P}/"
SRC_URI="mirror://cpan/authors/id/T/TM/TMTM/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
#KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

# Tests aren't possible since they require interaction with the DB's

DEPEND="dev-perl/Class-Data-Inheritable
		dev-perl/Class-Accessor
		dev-perl/Class-Trigger
		perl-core/File-Temp
		perl-core/Storable
		perl-core/Test-Simple
		dev-perl/Clone
		dev-perl/Ima-DBI
		perl-core/Scalar-List-Utils
		dev-perl/version
		dev-perl/UNIVERSAL-moniker"
