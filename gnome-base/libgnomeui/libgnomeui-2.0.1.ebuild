# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeui/libgnomeui-2.0.1.ebuild,v 1.1 2002/06/11 23:44:31 spider Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="User interface part of libgnome"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/pre-gnome2/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1" 

RDEPEND=">=x11-libs/gtk+-2.0.2
	>=sys-devel/perl-5.0.0
	>=sys-apps/gawk-3.1.0
	>=dev-libs/popt-1.6.0
	>=sys-devel/bison-1.28
	>=sys-devel/gettext-0.10.40
	>=media-sound/esound-0.2.27
	>=media-libs/audiofile-0.2.3
	>=gnome-base/libbonoboui-2.0.0
	>=gnome-base/gconf-1.1.11
	>=gnome-base/libgnome-2.0.1
	>=gnome-base/libgnomecanvas-2.0.1"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-0.9-r2 )"
DOCS="AUTHORS  COPYING.LIB INSTALL NEWS README"



