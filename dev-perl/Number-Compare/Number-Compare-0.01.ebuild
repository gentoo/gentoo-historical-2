# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Number-Compare/Number-Compare-0.01.ebuild,v 1.4 2004/05/07 18:39:43 gustavoz Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="numeric comparisons"
SRC_URI="http://www.cpan.org/modules/by-authors/id/R/RC/RCLAMP/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/R/RC/RCLAMP/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 ~alpha ~hppa ~mips ~ppc sparc"

DEPEND="dev-perl/Test-Simple"

