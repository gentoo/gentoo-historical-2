# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/gnome-terminal/gnome-terminal-2.22.3-r1.ebuild,v 1.4 2008/09/09 11:21:18 armin76 Exp $

inherit eutils gnome2 autotools

DESCRIPTION="The Gnome Terminal"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ~ppc ~ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="virtual/xft
	>=dev-libs/glib-2.15.2
	>=x11-libs/gtk+-2.12
	>=gnome-base/gconf-2.14
	>=x11-libs/startup-notification-0.8
	>=x11-libs/vte-0.15.3
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2.14
	>=gnome-base/libgnomeui-2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	>=app-text/gnome-doc-utils-0.3.2
	>=app-text/scrollkeeper-0.3.11"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

src_unpack() {
	gnome2_src_unpack

	# Use login shell by default (#12900)
	epatch "${FILESDIR}"/${PN}-2.22.0-default_shell.patch

	# terminal enhancement, inserts a space after a DND URL
	# patch by Zach Bagnall <yem@y3m.net> in #13801
	epatch "${FILESDIR}"/${PN}-2-dnd_url_add_space.patch

	# Fix deprecated API disabling in used libraries - this is not future-proof, bug 213340
	# Upstream bug: http://bugzilla.gnome.org/show_bug.cgi?id=523737
	sed -i -e '/DISABLE_DEPRECATED/d' \
		"${S}/src/Makefile.am" "${S}/src/Makefile.in"

	# Fix extra refs on tabs, bug #219964
	epatch "${FILESDIR}/${P}-tab-close-fix.patch"

	# patch gnome terminal to report as GNOME rather than xterm
	# This needs to resolve a few bugs (#120294,)
	# Leave out for now; causing too many problems
	#epatch ${FILESDIR}/${PN}-2.13.90-TERM-gnome.patch

	eautomake
}
