# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Proc-ProcessTable/Proc-ProcessTable-0.38.ebuild,v 1.7 2004/10/05 02:46:37 pvdabeel Exp $

inherit perl-module

S=${WORKDIR}/Proc-ProcessTable-0.38
DESCRIPTION="Unix process table information"
SRC_URI="http://www.cpan.org/modules/by-authors/id/D/DU/DURIST/Proc-ProcessTable-0.38.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/D/DU/DURIST/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 alpha ~hppa ~mips ppc ~sparc"
IUSE=""

DEPEND="dev-perl/Storable"
