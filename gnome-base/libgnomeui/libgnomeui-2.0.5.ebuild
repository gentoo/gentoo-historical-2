# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeui/libgnomeui-2.0.5.ebuild,v 1.11 2003/03/11 21:11:45 seemant Exp $

IUSE="doc"

inherit eutils gnome2

S="${WORKDIR}/${P}"
DESCRIPTION="User interface part of libgnome"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha"
LICENSE="GPL-2 LGPL-2.1" 

RDEPEND=">=x11-libs/gtk+-2.0.6
	>=dev-lang/perl-5.0.0
	>=sys-apps/gawk-3.1.0
	>=dev-libs/popt-1.6.0
	>=sys-devel/bison-1.28
	>=sys-devel/gettext-0.10.40
	>=media-sound/esound-0.2.29
	>=media-libs/audiofile-0.2.3
	>=gnome-base/libbonoboui-2.0.3
	>=gnome-base/gconf-1.2.1
	>=gnome-base/libgnome-2.0.4
	>=gnome-base/libgnomecanvas-2.0.4"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-0.9-r2 )"

DOCS="AUTHORS  COPYING.LIB INSTALL NEWS README"
