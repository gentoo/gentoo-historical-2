# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Balanced/Text-Balanced-1.95.ebuild,v 1.11 2004/12/23 16:11:05 nigoro Exp $

IUSE=""

inherit perl-module

DESCRIPTION="Extract balanced-delimiter substrings"
SRC_URI="http://www.cpan.org/modules/by-authors/id/D/DC/DCONWAY/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/D/DC/DCONWAY/${P}.readme"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 ~ppc sparc alpha hppa mips ~ppc64"

DEPEND="${DEPEND}"
