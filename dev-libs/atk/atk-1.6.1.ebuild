# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/atk/atk-1.6.1.ebuild,v 1.10 2004/08/05 20:08:10 gustavoz Exp $

inherit gnome2

DESCRIPTION="GTK+ & Gnome Accessibility Toolkit"
HOMEPAGE="http://developer.gnome.org/projects/gap/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc ~mips alpha arm hppa amd64 ~ia64 ppc64 macos"
IUSE="doc"

RDEPEND=">=dev-libs/glib-2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog README INSTALL NEWS"
