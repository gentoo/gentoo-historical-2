# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-dwerg/gtk-engines-dwerg-0.6.ebuild,v 1.6 2004/06/24 23:29:15 agriffis Exp $

inherit gtk-engines2

IUSE=""
DESCRIPTION="GTK+2 Dwerg Theme Engine"
SRC_URI="http://download.freshmeat.net/themes/dwerg/dwerg-default-${PV}.tar.gz"
HOMEPAGE="http://themes.freshmeat.net/projects/dwerg/"
KEYWORDS="x86 alpha ppc"
LICENSE="GPL-2"
SLOT="2"

DEPEND=">=x11-libs/gtk+-2"

src_unpack() {
	# Weird. The file is in bz2 but named gz ??
	cd ${WORKDIR}
	bzcat ${DISTDIR}/${A} | tar xvf -
}
