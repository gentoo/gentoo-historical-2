# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/giggle/giggle-0.4.ebuild,v 1.2 2009/01/26 20:24:45 ikelos Exp $

EAPI="1"

inherit gnome2

DESCRIPTION="GTK+ Frontend for GIT"
HOMEPAGE="http://live.gnome.org/giggle"
SRC_URI="http://ftp.imendio.com/pub/imendio/${PN}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-util/git-1.4.4.3
		 >=dev-libs/glib-2.12
		 >=x11-libs/gtk+-2.10
		 x11-libs/gtksourceview:2.0
		 >=gnome-base/libglade-2.4"
DEPEND="${RDEPEND}
		  sys-devel/gettext
		>=dev-util/pkgconfig-0.15
		>=dev-util/intltool-0.35"
