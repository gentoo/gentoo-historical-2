# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-mime-data/gnome-mime-data-2.0.0.ebuild,v 1.4 2002/07/23 21:38:13 gerk Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="MIME database for Gnome"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/pre-gnome2/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"

RDEPEND=">=dev-libs/glib-2.0.0"

DEPEND="${RDEPEND} 
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.17"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README"





