# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gtksourceview-sharp/gtksourceview-sharp-0.2.ebuild,v 1.4 2004/06/29 14:36:56 vapier Exp $

inherit mono

DESCRIPTION="A C# Binding to gtksourceview"
HOMEPAGE="http://www.go-mono.com/"
SRC_URI="http://www.go-mono.com/archive/beta1/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=">=dev-dotnet/mono-0.91
	>=x11-libs/gtk-sharp-0.91.1
	>=x11-libs/gtksourceview-0.7.0"

src_unpack() {
	unpack ${A}
	sed -i "s:\`monodoc:${D}\`monodoc:" ${S}/doc/Makefile.in
}

src_compile() {
	econf || die "./configure failed!"
	emake -j1 || die "make failed"
}

src_install() {
	dodir $(monodoc --get-sourcesdir)
	make DESTDIR=${D} install || die
}
