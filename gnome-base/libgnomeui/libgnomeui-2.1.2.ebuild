# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeui/libgnomeui-2.1.2.ebuild,v 1.3 2002/11/30 23:33:54 nall Exp $

IUSE="doc"

inherit gnome2 debug

S=${WORKDIR}/${P}
DESCRIPTION="User interface part of libgnome"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
KEYWORDS="x86 ~ppc"
LICENSE="GPL-2 LGPL-2.1" 

RDEPEND="=x11-libs/gtk+-2.1*
	>=sys-devel/perl-5.0.0
	>=sys-apps/gawk-3.1.0
	>=dev-libs/popt-1.6.0
	>=sys-devel/bison-1.28
	>=sys-devel/gettext-0.10.40
	>=media-sound/esound-0.2.29
	>=media-libs/audiofile-0.2.3
	=gnome-base/libbonoboui-2.1*
	>=gnome-base/gconf-1.2.1
	=gnome-base/libgnome-2.1*
	=gnome-base/libgnomecanvas-2.1*"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-0.9-r2 )"
DOCS="AUTHORS  COPYING.LIB INSTALL NEWS README"



