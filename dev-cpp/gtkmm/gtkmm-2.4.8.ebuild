# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtkmm/gtkmm-2.4.8.ebuild,v 1.1 2004/12/12 00:53:02 joem Exp $

inherit gnome2

DESCRIPTION="C++ interface for GTK+2"
HOMEPAGE="http://gtkmm.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2.4"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
IUSE=""
G2CONF="--disable-examples"

RDEPEND=">=dev-cpp/glibmm-2.4
	>=x11-libs/gtk+-2.4
	>=dev-libs/libsigc++-2.0
	>=dev-libs/atk-1.6"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS CHANGES ChangeLog PORTING NEWS README"
