# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gtkgl-sharp/gtkgl-sharp-0.05.ebuild,v 1.1 2004/06/02 17:16:47 latexer Exp $

inherit mono

DESCRIPTION="A C# OpenGL Binding"
HOMEPAGE="http://www.olympum.com/~bruno/gtkgl-sharp.html"
SRC_URI="http://ftp.novell.com/pub/forge/simetron/${PN}/${PV}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/x11
		>=dev-dotnet/mono-0.91
		>=x11-libs/gtk-sharp-0.91.1"

src_compile() {
	econf || die "./configure failed!"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
