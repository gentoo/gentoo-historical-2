# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gnome-spell/gnome-spell-1.0.5-r1.ebuild,v 1.1 2003/10/26 20:00:22 foser Exp $

IUSE=""

inherit gnome.org gnome2 libtool

DESCRIPTION="Gnome spellchecking component"
HOMEPAGE="http://www.gnome.org/"

KEYWORDS="~x86 ~sparc ~ppc ~alpha ~hppa"
SLOT="1"
LICENSE="GPL-2"

RDEPEND=">=gnome-base/libgnomeui-2.2
	>=gnome-base/libbonoboui-2.0
	>=gnome-base/libglade-2.0
	>=gnome-base/libbonobo-2.0
	>=gnome-base/ORBit2-2.0
	>=app-text/enchant-1"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
	>=dev-lang/perl-5.6.0"

DOCS="AUTHORS COPYING ChangeLog NEWS README"

src_unpack() {

	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-enchant.patch

	WANT_AUTOCONF_2_5=1 autoconf || die
	automake || die

}
