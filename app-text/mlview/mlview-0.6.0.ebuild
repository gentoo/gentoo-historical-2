# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/mlview/mlview-0.6.0.ebuild,v 1.1 2003/09/28 10:27:52 obz Exp $

inherit gnome2

DESCRIPTION="MLview is an XML editor for the GNOME environment"
HOMEPAGE="http://www.freespiders.org/projects/gmlview/"
LICENSE="GPL-2"

IUSE=""
SLOT="0"
KEYWORDS="~x86"

RDEPEND=">=gnome-base/libgnomeui-2
	>=dev-libs/libxml2-2.4.30
	>=x11-libs/gtk+-2
	>=gnome-base/libglade-2"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.25
	sys-devel/gettext"

DOCS="ABOUT-NLS AUTHORS COPYING ChangeLog INSTALL NEWS README TODO"
USE_DESTDIR="1"

src_unpack() {

	unpack ${A}
	cd ${S}
	# patch for the Makefile using ${prefix} where it really wants
	# to use ${DESTDIR}, <obz@gentoo.org>
	epatch ${FILESDIR}/${P}-Makefile.in.patch

}


