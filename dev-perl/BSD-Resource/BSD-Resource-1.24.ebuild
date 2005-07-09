# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/BSD-Resource/BSD-Resource-1.24.ebuild,v 1.10 2005/07/09 23:17:53 swegener Exp $

inherit perl-module eutils

DESCRIPTION="Perl module for BSD process resource limit and priority functions"
HOMEPAGE="http://www.cpan.org/modules/by-module/BSD/${P}.readme"
SRC_URI="mirror://cpan/authors/id/J/JH/JHI/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc sparc alpha"
IUSE=""
SRC_TEST="do"

src_unpack(){
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/portage_niceness.patch
}
