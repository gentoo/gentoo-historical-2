# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gnutu/gnutu-2.0.ebuild,v 1.1 2005/10/03 03:53:24 chriswhite Exp $

inherit mono eutils

DESCRIPTION="GNU Student's Timetable for polish users"
HOMEPAGE="http://www.gnutu.org/"
SRC_URI="http://www.gnutu.org/download/sources/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-lang/mono
	>=dev-dotnet/gtk-sharp-1.9.5
	>=dev-dotnet/glade-sharp-1.9.5"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-event.patch
}

src_install() {
	make install DESTDIR=${D} || die
}
