# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libgksu/libgksu-2.0.0.ebuild,v 1.6 2006/11/15 13:15:26 corsair Exp $

inherit gnome2

MY_PN="${PN}2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A library for integration of su into applications"
HOMEPAGE="http://www.nongnu.org/gksu/"
SRC_URI="http://people.debian.org/~kov/gksu/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="nls doc"

DEPEND="doc? ( >=dev-util/gtk-doc-1.2-r1 )
	nls? ( >=sys-devel/gettext-0.14.1 )
	>=x11-libs/gtk+-2.4
	>=gnome-base/gconf-2
	gnome-base/gnome-keyring
	>=gnome-base/libgtop-2
	>=gnome-base/libglade-2
	>=dev-util/pkgconfig-0.19
	x11-libs/startup-notification"
RDEPEND="${DEPEND}
	app-admin/sudo
	dev-util/intltool"

USEDESTDIR="1"
G2CONF="$(use_enable nls)"
