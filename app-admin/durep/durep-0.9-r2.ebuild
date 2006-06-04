# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/durep/durep-0.9-r2.ebuild,v 1.1 2006/06/04 09:35:47 vapier Exp $

inherit eutils

DESCRIPTION="A perl script designed for monitoring disk usage in a more visual way than du."
HOMEPAGE="http://www.hibernaculum.net/durep/"
SRC_URI="http://www.hibernaculum.net/download/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-lang/perl
	dev-perl/MLDBM"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gigabyte.patch
	epatch "${FILESDIR}"/${P}-color-output.patch
}

src_install() {
	dobin durep || die
	doman durep.1
	dodoc BUGS CHANGES README THANKS
	dohtml -A cgi *.cgi *.css *.png
}
