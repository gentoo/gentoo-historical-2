# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-NCopy/File-NCopy-0.34.ebuild,v 1.4 2004/02/22 20:41:51 agriffis Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Copy file, file Copy file[s] | dir[s], dir"
SRC_URI="http://www.cpan.org/modules/by-authors/id/M/MZ/MZSANFORD/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/M/MZ/MZSANFORD/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 ~alpha ~hppa ~mips ~ppc ~sparc"

DEPEND="dev-perl/File-Spec"
