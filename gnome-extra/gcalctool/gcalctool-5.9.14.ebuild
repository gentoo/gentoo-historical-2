# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gcalctool/gcalctool-5.9.14.ebuild,v 1.1 2007/03/27 19:59:18 dang Exp $

inherit gnome2

DESCRIPTION="A calculator application for GNOME"
HOMEPAGE="http://calctool.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6
	>=dev-libs/glib-2
	>=dev-libs/atk-1.5
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/gconf-2
	!<gnome-extra/gnome-utils-2.3"
DEPEND="${RDEPEND}
	  sys-devel/gettext
	  app-text/scrollkeeper
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	>=app-text/gnome-doc-utils-0.3.2"

DOCS="AUTHORS ChangeLog* MAINTAINERS NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} --enable-gnome"
}

