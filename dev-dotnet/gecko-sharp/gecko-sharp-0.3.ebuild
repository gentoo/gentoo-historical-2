# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gecko-sharp/gecko-sharp-0.3.ebuild,v 1.1 2004/05/06 15:09:33 latexer Exp $

inherit mono

DESCRIPTION="A Gtk# Mozilla binding"
HOMEPAGE="http://www.go-mono.com/"
SRC_URI="http://www.go-mono.com/archive/beta1/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""

DEPEND=">=dev-dotnet/mono-0.91
		>=x11-libs/gtk-sharp-0.91.1
		net-www/mozilla"

src_compile() {
	econf || die "./configure failed!"
	MAKEOPTS="-j1" make || die "Make failed. You may need to unmerge gecko-sharp and re-emerge it if you are upgrading from an earlier version."
}

src_install() {
	make DESTDIR=${D} install || die
}
