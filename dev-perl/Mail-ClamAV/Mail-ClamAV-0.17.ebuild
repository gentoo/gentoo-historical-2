# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-ClamAV/Mail-ClamAV-0.17.ebuild,v 1.4 2006/03/30 23:00:54 agriffis Exp $

inherit perl-module

DESCRIPTION="Perl extension for the clamav virus scanner."
HOMEPAGE="http://search.cpan.org/~sabeck/${P}"
SRC_URI="mirror://cpan/authors/id/S/SA/SABECK/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~ia64 sparc x86"

IUSE=""

DEPEND=">=app-antivirus/clamav-0.80
	dev-perl/Inline"

RDEPEND="${DEPEND}"

src_install() {
	perl-module_src_install
	dodoc README Changes || die
}


