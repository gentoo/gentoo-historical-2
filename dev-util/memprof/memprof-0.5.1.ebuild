# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/memprof/memprof-0.5.1.ebuild,v 1.2 2002/12/09 04:21:16 manson Exp $

inherit gnome2

S=${WORKDIR}/${P}
DESCRIPTION="MemProf - Profiling and leak detection"
HOMEPAGE="http://www.gnome.org/projects/memprof/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc "

DEPEND=">=x11-libs/gtk+-2
	>=gnome-base/gconf-1.2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	sys-devel/libtool"

RDEPEND="${DEPEND}
	sys-devel/gettext"

DOCS="AUTHORS COPYING ChangeLog README NEWS TODO"
