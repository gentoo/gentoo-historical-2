# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-begtk/gtk-engines-begtk-1.0.1-r1.ebuild,v 1.7 2004/06/24 23:28:42 agriffis Exp $

inherit gtk-engines2

DESCRIPTION="GTK+1 BeGTK Theme Engine"
SRC_URI="mirror://debian/pool/main/b/${PN}/${PN}_${PV}.orig.tar.gz"

KEYWORDS="x86 ppc sparc ~alpha hppa"
IUSE=""
SLOT="1"
LICENSE="GPL-2"

DEPEND="=x11-libs/gtk+-1.2*"

S=${WORKDIR}/GTKBeEngine


