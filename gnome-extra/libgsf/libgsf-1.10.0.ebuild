# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgsf/libgsf-1.10.0.ebuild,v 1.10 2005/04/28 09:14:54 kloeri Exp $

inherit eutils gnome2

DESCRIPTION="The GNOME Structured File Library"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="x86 alpha amd64 arm hppa ia64 ~mips ppc sparc ppc64"
IUSE="gnome doc"

# FIXME : should add optional bz2 support
RDEPEND=">=dev-libs/libxml2-2.4.16
	>=dev-libs/glib-2
	>=sys-libs/zlib-1.1.4
	 gnome? ( >=gnome-base/libbonobo-2
	  	>=gnome-base/gnome-vfs-2 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=sys-apps/sed-4
	doc? ( >=dev-util/gtk-doc-0.9 )"

G2CONF="${G2CONF} $(use_with gnome)"

DOCS="AUTHORS ChangeLog INSTALL NEWS README"
