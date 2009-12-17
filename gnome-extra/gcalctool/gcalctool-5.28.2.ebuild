# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gcalctool/gcalctool-5.28.2.ebuild,v 1.1 2009/12/17 22:58:57 eva Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A calculator application for GNOME"
HOMEPAGE="http://calctool.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.14.0
	>=dev-libs/glib-2
	>=dev-libs/atk-1.5
	>=gnome-base/gconf-2
	!<gnome-extra/gnome-utils-2.3"
DEPEND="${RDEPEND}
	sys-devel/gettext
	app-text/scrollkeeper
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	>=app-text/gnome-doc-utils-0.3.2"

DOCS="AUTHORS ChangeLog* MAINTAINERS NEWS README"

src_prepare() {
	gnome2_src_prepare

	# Fix bashisms
	sed 's/\[\[\(.*\)\]\]/[\1]/g' -i configure.in configure || die "sed failed"
}
