# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/atk/atk-1.2.2.ebuild,v 1.4 2003/02/22 00:04:14 agriffis Exp $

inherit libtool gnome2

IUSE="doc"
S=${WORKDIR}/${P}
DESCRIPTION="Gnome Accessibility Toolkit"
HOMEPAGE="http://developer.gnome.org/projects/gap/"

SLOT="1"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ~ppc alpha"

RDEPEND=">=dev-libs/glib-2"

DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-0.9-r2 )
	>=dev-util/pkgconfig-0.12.0"

LIBTOOL_FIX="1"

DOCS="AUTHORS ChangeLog COPYING README* INSTALL NEWS"
