# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-mime-data/gnome-mime-data-2.4.1.ebuild,v 1.10 2004/06/24 21:57:46 agriffis Exp $

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

