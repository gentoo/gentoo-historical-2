# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Gtk2-Html2/Gtk2-Html2-0.04.ebuild,v 1.1 2005/01/18 11:12:41 mcummings Exp $

inherit perl-module

DESCRIPTION="Bindings for GtkHtml with Gtk2.x"
SRC_URI="mirror://sourceforge/gtk2-perl/${P}.tar.gz"
HOMEPAGE="http://gtk2-perl.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="${DEPEND}
	>=x11-libs/gtk+-2*
	>=gnome-extra/libgtkhtml-2.0.0
	>=dev-perl/glib-perl-1.012
	>=dev-perl/gtk2-perl-1.012"


