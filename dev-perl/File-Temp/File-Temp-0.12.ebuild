# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Temp/File-Temp-0.12.ebuild,v 1.13 2004/12/13 05:41:30 weeve Exp $

inherit perl-module

MY_P=File-Temp-${PV}
S=${WORKDIR}/${MY_P}
CATEGORY="dev-perl"

DESCRIPTION="File::Temp can be used to create and open temporary files in a safe way."
HOMEPAGE="http://www.cpan.org/modules/by-module/File/${MY_P}.readme"
SRC_URI="http://www.cpan.org/modules/by-module/File/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="x86 amd64 ppc sparc alpha"
IUSE=""
