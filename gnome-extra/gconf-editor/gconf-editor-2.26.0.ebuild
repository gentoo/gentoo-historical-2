# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gconf-editor/gconf-editor-2.26.0.ebuild,v 1.9 2010/01/18 00:08:53 jer Exp $

EAPI="2"

inherit autotools eutils gnome2

DESCRIPTION="An editor to the GNOME 2 config system"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="policykit test"

RDEPEND=">=x11-libs/gtk+-2.6
	>=gnome-base/gconf-2.12.0
	policykit? (
		>=sys-auth/policykit-0.7
		>=dev-libs/dbus-glib-0.71 )"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	sys-devel/gettext
	app-text/gnome-doc-utils
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.19
	test? ( ~app-text/docbook-xml-dtd-4.1.2 )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		$(use_with policykit)"
}

src_prepare() {
	gnome2_src_prepare

	# Fix automagic policykit, bug #266031
	epatch "${FILESDIR}/${P}-optional-policykit.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}
