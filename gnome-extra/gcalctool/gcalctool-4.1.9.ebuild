# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gcalctool/gcalctool-4.1.9.ebuild,v 1.1 2002/10/27 15:04:47 foser Exp $

inherit gnome2 debug

S=${WORKDIR}/${P}
DESCRIPTION="A scientific calculator for Gnome2"
HOMEPAGE="http://fileroller.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=x11-libs/gtk+-2"

RDEPEND="${DEPEND}
	sys-devel/gettext"

DOCS="AUTHORS COPYING ChangeLog NEWS README TODO"
