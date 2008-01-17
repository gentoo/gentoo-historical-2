# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgsf/libgsf-1.12.1.ebuild,v 1.14 2008/01/17 19:20:08 grobian Exp $

inherit gnome2

DESCRIPTION="The GNOME Structured File Library"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 ppc ppc64 sh sparc x86"
IUSE="bzip2 doc gnome"

RDEPEND=">=dev-libs/libxml2-2.4.16
	>=dev-libs/glib-2.6
	sys-libs/zlib
	gnome? ( >=gnome-base/libbonobo-2
		>=gnome-base/gnome-vfs-2.2 )
	bzip2? ( app-arch/bzip2 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )"

G2CONF="${G2CONF} $(use_with bzip2 bz2) $(use_with gnome)"

DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README TODO"
