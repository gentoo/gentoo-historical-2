# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unp/unp-1.0.14.ebuild,v 1.4 2008/01/06 01:10:47 hanno Exp $

DESCRIPTION="Script for unpacking various file formats"
HOMEPAGE="http://packages.qa.debian.org/u/unp.html"
SRC_URI="mirror://debian/pool/main/u/unp/${PN}_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"
IUSE=""
DEPEND="dev-lang/perl"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	dobin unp
}
