# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-NCopy/File-NCopy-0.34.ebuild,v 1.17 2006/01/27 20:28:28 hansmi Exp $

inherit perl-module

DESCRIPTION="Copy file, file Copy file[s] | dir[s], dir"
SRC_URI="mirror://cpan/authors/id/M/MZ/MZSANFORD/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/M/MZ/MZSANFORD/${P}.readme"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

DEPEND="perl-core/File-Spec"
