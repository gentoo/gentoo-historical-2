# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gtodo/gtodo-0.13.5.ebuild,v 1.3 2004/02/22 14:51:41 brad_mssw Exp $

inherit gnome2
inherit debug flag-o-matic

strip-flags

IUSE=""


S=${WORKDIR}/${P}
DESCRIPTION="Gtodo is a Gtk+-2.0 Todo list manager written for use with gnome 2."
HOMEPAGE="http://gtodo.qballcow.nl/"
SRC_URI="mirror://sourceforge/gtodo/${P}.tar.gz"
KEYWORDS="x86 amd64"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=x11-libs/gtk+-2.0
	>=dev-libs/libxml2-2.0
	>=gnome-base/gconf-2.0"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README"
