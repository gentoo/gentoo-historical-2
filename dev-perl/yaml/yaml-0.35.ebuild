# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/yaml/yaml-0.35.ebuild,v 1.14 2004/12/22 11:55:42 nigoro Exp $

inherit perl-module

MY_P="YAML-${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="YAML Ain't Markup Language (tm)"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/I/IN/INGY/${MY_P}.readme"
SRC_URI="http://www.cpan.org/modules/by-authors/id/I/IN/INGY/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 hppa mips ppc sparc x86 ~ppc64"
IUSE=""

src_compile() {
	echo "" | perl-module_src_compile
}
