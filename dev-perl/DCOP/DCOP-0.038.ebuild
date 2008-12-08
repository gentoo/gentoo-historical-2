# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DCOP/DCOP-0.038.ebuild,v 1.1 2008/12/08 02:14:19 robbat2 Exp $

inherit perl-module

DESCRIPTION="Extensible inheritable Perl class to dcop."
SRC_URI="mirror://cpan/authors/id/J/JC/JCMULLER/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/J/JC/JCMULLER/${P}.readme"

RDEPEND="kde-base/kdelibs"

IUSE=""

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

SRC_TEST="do"
