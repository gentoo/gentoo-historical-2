# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeprintui/libgnomeprintui-1.116.0.ebuild,v 1.15 2004/11/08 19:19:04 vapier Exp $

inherit gnome2 eutils

DESCRIPTION="user interface libraries for gnome print"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="mirror://gnome/2.0.0/sources/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2"
KEYWORDS="x86 ppc sparc alpha arm"
IUSE=""

RDEPEND=">=gnome-base/libgnomeui-2.0.1
	<gnome-base/libgnomeprint-2.1
	>=gnome-base/libgnomecanvas-2.0.1"

DEPEND="${RDEPEND} >=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS COPYING* ChangeLog INSTALL NEWS README"

src_unpack() {

	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PN}-1-syntax_fix.patch

}
