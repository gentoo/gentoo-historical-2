# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Find-Rule/File-Find-Rule-0.28.ebuild,v 1.1 2004/06/05 19:15:45 mcummings Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Alternative interface to File::Find"
SRC_URI="http://www.cpan.org/modules/by-authors/id/R/RC/RCLAMP/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/R/RC/RCLAMP/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="~x86 ~alpha ~hppa ~mips ~ppc ~sparc"
style="builder"

SRC_TEST="do"

DEPEND="dev-perl/Test-Simple
	dev-perl/File-Spec
	dev-perl/Number-Compare
	dev-perl/Text-Glob
	dev-perl/module-build"

