# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nautilus-cd-burner/nautilus-cd-burner-0.4.1.ebuild,v 1.3 2003/08/07 03:42:03 vapier Exp $

inherit gnome2 debug

DESCRIPTION="CDR plugin for Nautilus"
SRC_URI="mirror://gnome/sources/${PN}/0.4/${P}.tar.gz"
HOMEPAGE=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"

RDEPEND=">=gnome-base/nautilus-2.1
	>=gnome-base/gnome-vfs-2.0
	app-cdr/cdrtools"
DEPEND=">=dev-util/intltool-0.22
	>=dev-util/pkgconfig-0.9.0
	${RDEPEND}"

DOCS="AUTHORS ChangeLog COPYING INSTALL NEWS README"
