# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/atk/atk-1.6.0.ebuild,v 1.7 2004/05/29 03:19:51 pvdabeel Exp $

inherit gnome2

IUSE="doc"
DESCRIPTION="GTK+ & Gnome Accessibility Toolkit"
HOMEPAGE="http://developer.gnome.org/projects/gap/"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="x86 ppc ~alpha sparc hppa amd64 ~ia64 mips"

RDEPEND=">=dev-libs/glib-2"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog COPYING README INSTALL NEWS"
