# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gtk-sharp/gtk-sharp-1.0.2.ebuild,v 1.1 2004/10/26 21:52:16 latexer Exp $

inherit eutils mono

DESCRIPTION="Gtk# is a C# language binding for the GTK2 toolkit and GNOME libraries"
SRC_URI="http://www.go-mono.com/archive/${PV}/${P}.tar.gz"
HOMEPAGE="http://gtk-sharp.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="gnome gnomedb libgda gtkhtml"

RDEPEND=">=sys-apps/sed-4.0
	>=dev-dotnet/mono-1.0.2
	>=x11-libs/gtk+-2.2
	>=gnome-base/libglade-2
	>=gnome-base/orbit-2.8.3
	gnome? ( >=gnome-base/libgnomecanvas-2.2
		>=gnome-base/libgnomeui-2.2
		>=gnome-base/libgnomeprintui-2.2 )
	libgda? ( >=gnome-extra/libgda-0.11 )
	gnomedb? ( >=gnome-extra/libgnomedb-0.11 )
	gtkhtml? ( =gnome-extra/libgtkhtml-3.0.10* )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

KEYWORDS="~x86 ~ppc"

src_unpack() {
	unpack ${A}

	# disable building of samples (#16015)
	cd ${S}
	sed -i -e "s:sample::" Makefile.in
}

src_compile() {
	econf || die "./configure failed"
	MAKEOPTS="-j1" MONO_PATH=${S} emake || die
}

src_install () {
	make GACUTIL_FLAGS="/root ${D}/usr/lib /gacdir /usr/lib /package ${PN}" \
		DESTDIR=${D} install || die

	dodoc README* ChangeLog
}
