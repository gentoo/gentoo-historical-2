# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeprintui/libgnomeprintui-2.2.1.2.ebuild,v 1.9 2003/10/09 20:54:51 foser Exp $

inherit gnome2 eutils

IUSE="doc"

S=${WORKDIR}/${P}
DESCRIPTION="user interface libraries for gnome print"
HOMEPAGE="http://www.gnome.org/"

SLOT="2.2"
KEYWORDS="x86 ppc alpha sparc hppa amd64"
LICENSE="GPL-2 LGPL-2.1"

RDEPEND="=gnome-base/libgnomeprint-${PV}*
	>=gnome-base/libgnomecanvas-2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-0.10 )"

DOCS="AUTHORS COPYING* ChangeLog INSTALL NEWS README"

src_unpack() {

	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PN}-2-syntax_fix.patch

}
