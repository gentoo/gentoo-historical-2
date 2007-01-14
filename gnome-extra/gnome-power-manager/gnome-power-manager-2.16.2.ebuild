# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-power-manager/gnome-power-manager-2.16.2.ebuild,v 1.12 2007/01/14 01:38:04 kloeri Exp $

GNOME_TARBALL_SUFFIX="gz"

inherit gnome2

DESCRIPTION="Gnome Power Manager"
HOMEPAGE="http://www.gnome.org/projects/gnome-power-manager/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ia64 ppc ppc64 sparc x86"
IUSE="doc libnotify"

RDEPEND=">=dev-libs/glib-2.6.0
	>=x11-libs/gtk+-2.10.0
	>=gnome-base/libgnome-2.14.0
	>=gnome-base/libgnomeui-2.10.0
	>=sys-apps/hal-0.5.7-r1
	>=gnome-base/libglade-2.5.0
	>=x11-libs/libwnck-2.10.0
	>=x11-libs/cairo-1.0.0
	>=gnome-base/gconf-2
	|| (
		>=dev-libs/dbus-glib-0.71
		~sys-apps/dbus-0.62 )
	libnotify? (
		>=x11-libs/libnotify-0.4.3
		>=x11-misc/notification-daemon-0.2.1 )

	x11-libs/libX11
	x11-libs/libXext"

# docbook-sgml-utils and docbook-sgml-dtd-4.1 used for creating man pages
# (files under ${S}/man).
#
# docbook-xml-dtd-4.4 and -4.1.2 are used by the xml files under ${S}/docs.
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	>=app-text/gnome-doc-utils-0.3.2
	~app-text/docbook-xml-dtd-4.3
	doc? (
		app-text/docbook-sgml-utils
		~app-text/docbook-sgml-dtd-4.1
		app-text/xmlto
		~app-text/docbook-xml-dtd-4.4
		~app-text/docbook-xml-dtd-4.1.2 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"


pkg_setup() {
	G2CONF="$(use_enable doc docbook-docs) \
		$(use_enable libnotify) \
		--enable-actions-menu --with-dpms-ext"
}

src_unpack() {
	gnome2_src_unpack

	if use doc; then
		# Actually install all html files, not just the index
		sed -i -e 's:\(htmldoc_DATA = \).*:\1$(SPEC_HTML_FILES):' \
			${S}/docs/Makefile.in
	else
		# Remove the docbook2man rules here since it's not handled by a proper
		# parameter in configure.in.
		sed -i -e 's:@HAVE_DOCBOOK2MAN_TRUE@.*::' ${S}/man/Makefile.in
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst

	einfo "You will need the masked pam_console to be able to"
	einfo "suspend/hibernate, or you will need to:"
	einfo "touch /var/run/console/<USERNAME>"
	einfo "after each boot"
}
