# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gtk-cpuspeedy/gtk-cpuspeedy-0.1.ebuild,v 1.6 2004/05/11 07:47:43 mr_bones_ Exp $

DESCRIPTION="Graphical GTK+-2 frontend for cpuspeedy."
SRC_URI="mirror://sourceforge/cpuspeedy/${P}.tar.gz"
HOMEPAGE="http://cpuspeedy.sourceforge.net/"
KEYWORDS="~x86 ~ppc"
SLOT="0"
LICENSE="GPL-2"
IUSE=""
RESTRICT="nomirror"
DEPEND="sys-devel/automake
	sys-devel/autoconf
	dev-util/pkgconfig
	sys-devel/gcc
	dev-libs/glib
	dev-libs/atk
	x11-libs/pango
	virtual/x11
	media-libs/fontconfig
	media-libs/freetype
	sys-libs/zlib
	dev-libs/expat
	virtual/glibc
	>=x11-libs/gtk+-2"

RDEPEND=">=sys-apps/cpuspeedy-0.2
	dev-libs/glib
	dev-libs/atk
	x11-libs/pango
	virtual/x11
	media-libs/fontconfig
	media-libs/freetype
	sys-libs/zlib
	dev-libs/expat
	virtual/glibc
	>=x11-libs/gtk+-2
	x86? ( x11-libs/gksu )"

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog INSTALL COPYING README
}
