# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-mime-data/gnome-mime-data-2.4.1.ebuild,v 1.9 2004/04/28 01:12:44 geoman Exp $

inherit gnome2

DESCRIPTION="MIME data for Gnome"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc alpha sparc hppa amd64 ia64 mips"

DEPEND=">=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.22"
RDEPEND=""
# to avoid RDEPEND=DEPEND, we state RDEPEND as empty
DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README"

