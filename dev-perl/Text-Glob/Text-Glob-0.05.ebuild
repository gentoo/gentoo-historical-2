# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Glob/Text-Glob-0.05.ebuild,v 1.2 2003/06/21 21:36:38 drobbins Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Match globbing patterns against text"
SRC_URI="http://www.cpan.org/modules/by-authors/id/R/RC/RCLAMP/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/R/RC/RCLAMP/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 ~alpha ~arm ~hppa ~mips ~ppc ~sparc"

DEPEND="dev-perl/Test-Simple"

