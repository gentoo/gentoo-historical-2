# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ggv/ggv-2.0.0.ebuild,v 1.6 2003/09/07 22:32:10 foser Exp $

inherit gnome2

DESCRIPTION="your favourite PostScript previewer"
HOMEPAGE="http://www.gnome.org/"

IUSE="doc"
SLOT="0"
LICENSE="GPL-2 FDL-1.1"
KEYWORDS="x86 ppc ~alpha ~sparc hppa amd64"

RDEPEND=">=gnome-base/libgnomeui-2
	>=gnome-base/ORBit2-2.4.1
	app-text/ghostscript
	>=dev-libs/popt-1.6"

DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	>=dev-util/pkgconfig-0.12.0"

DOC="AUTHORS ChangeLog COPYING* MAINTAINERS TODO NEWS README"
