# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gtksourceview-sharp/gtksourceview-sharp-0.5.ebuild,v 1.6 2005/03/11 03:15:35 latexer Exp $

inherit mono multilib

DESCRIPTION="A C# Binding to gtksourceview"
HOMEPAGE="http://www.go-mono.com/"
SRC_URI="http://www.go-mono.com/archive/1.0/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"

IUSE=""

DEPEND=">=dev-lang/mono-1.0
		>=dev-dotnet/gtk-sharp-1.0
		>=x11-libs/gtksourceview-1.0.0"


src_unpack() {
	if [ ! -f ${ROOT}/usr/share/gapi/gnome-api.xml ]
	then
		eerror "Support for gnome libraries missing from gtk-sharp!"
		eerror "Please re-emerge gtk-sharp with 'gnome' in USE,"
		eerror "then emerge gtksourceview-sharp."
		die "Gnome support not found in gtk-sharp."
	fi

	unpack ${A}
	sed -i "s:\`monodoc:${D}\`monodoc:" ${S}/doc/Makefile.in
}

src_compile() {
	econf || die "./configure failed!"
	MAKEOPTS="-j1" make || die "make failed"
}

src_install() {
	dodir $(monodoc --get-sourcesdir)
	make GACUTIL_FLAGS="/root ${D}/usr/$(get_libdir) /gacdir /usr/$(get_libdir) -package gtk-sharp" \
		DESTDIR=${D} install || die
}
