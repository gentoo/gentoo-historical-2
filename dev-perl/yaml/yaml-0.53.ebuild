# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/yaml/yaml-0.53.ebuild,v 1.1 2006/01/22 16:50:04 mcummings Exp $

inherit perl-module

MY_P="YAML-${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="YAML Ain't Markup Language (tm)"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/I/IN/INGY/${MY_P}.readme"
SRC_URI="mirror://cpan/authors/id/I/IN/INGY/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
#KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
KEYWORDS="~hppa ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=perl-core/Test-Simple-0.62
		>=dev-perl/Test-Base-0.47
		>=dev-perl/Class-Spiffy-0.12
		>=dev-lang/perl-5.6.1"

SRC_TEST="do"

src_compile() {
	echo "" | perl-module_src_compile
}
