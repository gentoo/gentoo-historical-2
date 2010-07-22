# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/mkcdtoc/mkcdtoc-1.0.ebuild,v 1.1 2010/07/22 20:31:22 sbriesen Exp $

inherit eutils

DESCRIPTION="command-line utility to create toc-files for cdrdao"
HOMEPAGE="http://sourceforge.net/projects/mkcdtoc/"
SRC_URI="mirror://sourceforge/mkcdtoc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.8.0"
RDEPEND="${DEPEND}"

src_compile() {
	emake PREFIX="/usr" || die "emake failed"
}

src_install () {
	emake PREFIX="/usr" DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
