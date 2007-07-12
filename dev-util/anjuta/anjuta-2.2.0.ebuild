# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/anjuta/anjuta-2.2.0.ebuild,v 1.1 2007/07/12 05:19:30 compnerd Exp $

inherit eutils gnome2 eutils autotools

DESCRIPTION="A versatile IDE for GNOME"
HOMEPAGE="http://www.anjuta.org"
SRC_URI="mirror://sourceforge/${PN}/${PF}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc glade inherit-graph sourceview subversion valgrind"

RDEPEND=">=dev-libs/glib-2.8.0
	 >=x11-libs/gtk+-2.8.0
	 >=gnome-base/orbit-2.6.0
	 >=gnome-base/libglade-2.3.0
	 >=gnome-base/libgnome-2.12.0
	 >=gnome-base/libgnomeui-2.12.0
	 >=gnome-base/libgnomeprint-2.12.0
	 >=gnome-base/libgnomeprintui-2.12.0
	 >=gnome-base/gnome-vfs-2.12.0
	 >=gnome-base/gconf-2.12.0
	 >=x11-libs/vte-0.13.1
	 >=dev-libs/libxml2-2.4.23
	 >=x11-libs/pango-1.1.1
	 >=dev-libs/gdl-0.7.5
	 >=dev-util/devhelp-0.13
	 >=app-text/gnome-doc-utils-0.3.2
	 >=dev-libs/gnome-build-0.1.6
	 >=dev-libs/libpcre-5.0
	 >=x11-libs/libwnck-2.12
	 >=sys-devel/binutils-2.15.92
	   dev-libs/libxslt
	   sys-devel/autogen
	 glade? ( >=dev-util/glade-3.1.4 )
	 inherit-graph? ( >=media-gfx/graphviz-2.6.0 )
	 sourceview? (
					>=x11-libs/gtk+-2.10.0
					>=gnome-base/libgnome-2.14.0
					>=x11-libs/gtksourceview-1.4.0
				 )
	 subversion? (
					>=dev-util/subversion-1.1.4
					>=net-misc/neon-0.24.5
					dev-libs/apr
				 )
	 valgrind? ( dev-util/valgrind )"
DEPEND="${RDEPEND}
	  dev-lang/perl
	>=sys-devel/gettext-0.14
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.20
	doc? ( >=dev-util/gtk-doc-1.0 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-plugin-devhelp \
		$(use_enable debug) \
		$(use_enable doc gtk-doc) \
		$(use_enable glade plugin-glade) \
		$(use_enable valgrind plugin-valgrind) \
		$(use_enable sourceview plugin-sourceview) \
		$(use_enable subversion plugin-subversion) \
		$(use_enable inherit-graph plugin-class-inheritance)"

	# Enable scintilla by default
	if ! use sourceview ; then
		G2CONF="${G2CONF} --enable-plugin-scintilla"
	fi
}

src_unpack() {
	gnome2_src_unpack
	cd ${S}

	# Patch to prevent an access violation (bug #164740)
	epatch ${FILESDIR}/${PN}-2.1.0-sandbox-fix.patch
}

src_install() {
	# Install user docs into /usr/share/doc/${PF}/
	sed -i -e "s:doc/${PN}:doc/${PF}:g" Makefile
	sed -i -e "s:doc/${PN}:doc/${PF}/html:g" doc/Makefile

	gnome2_src_install
	prepalldocs
}

pkg_postinst() {
	gnome2_pkg_postinst

	ebeep 1
	elog "Some project templates may require additional development"
	elog "libraries to function correctly. It goes beyond the scope"
	elog "of this ebuild to provide them."
	epause 5
}
