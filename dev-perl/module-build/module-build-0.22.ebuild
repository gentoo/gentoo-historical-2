# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/module-build/module-build-0.22.ebuild,v 1.4 2004/06/05 13:23:46 mcummings Exp $

inherit perl-module

MY_P="Module-Build-${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="Build and install Perl modules"
SRC_URI="http://www.cpan.org/modules/by-authors/id/K/KW/KWILLIAMS/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/K/KW/KWILLIAMS/${MY_P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="~x86 alpha ~hppa ~mips ~ppc ~sparc ~amd64"

DEPEND="dev-perl/module-info
		dev-perl/yaml
		dev-perl/extutils-parsexs
		>=dev-perl/Archive-Tar-1.09"

style="builder"
