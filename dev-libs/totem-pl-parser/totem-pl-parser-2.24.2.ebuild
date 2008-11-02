# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/totem-pl-parser/totem-pl-parser-2.24.2.ebuild,v 1.1 2008/11/02 07:17:21 leio Exp $

inherit gnome.org

DESCRIPTION="Playlist parsing library"
HOMEPAGE="http://www.gnome.org/projects/totem/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc hal"

RDEPEND=">=dev-libs/glib-2.16.3
	>=x11-libs/gtk+-2.12
	>=gnome-extra/evolution-data-server-1.12
	hal? (
		=sys-apps/hal-0.5*
		>=sys-apps/dbus-1.0 )"
DEPEND="${RDEPEND}
	!<media-video/totem-2.21
	>=dev-util/intltool-0.40
	doc? ( dev-util/gtk-doc )"

src_compile() {
	econf $(use_with hal)
	emake || die "build failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
