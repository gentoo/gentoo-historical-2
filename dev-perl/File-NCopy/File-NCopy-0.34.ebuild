# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-NCopy/File-NCopy-0.34.ebuild,v 1.11 2005/04/25 15:49:35 mcummings Exp $

inherit perl-module

DESCRIPTION="Copy file, file Copy file[s] | dir[s], dir"
SRC_URI="mirror://cpan/authors/id/M/MZ/MZSANFORD/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/M/MZ/MZSANFORD/${P}.readme"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 alpha ~hppa ~mips ~ppc sparc ~ppc64"
IUSE=""

DEPEND="dev-perl/File-Spec"
