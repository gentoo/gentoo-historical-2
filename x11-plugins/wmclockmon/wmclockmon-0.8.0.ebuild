# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmclockmon/wmclockmon-0.8.0.ebuild,v 1.2 2004/06/24 23:06:50 agriffis Exp $

IUSE=""

DESCRIPTION="digital clock dockapp with seven different styles with a LCD or LED display. Also has a Internet Time feature."
SRC_URI="http://tnemeth.free.fr/projets/programmes/${P}.tar.gz"
HOMEPAGE="http://tnemeth.free.fr/projets/dockapps.html"

SLOT="0"
KEYWORDS="~x86 ~sparc amd64 ppc"
LICENSE="GPL-2"

DEPEND="virtual/x11
	=x11-libs/gtk+-1.2*"

src_install () {
	einstall || die "make install failed"

	dodoc AUTHORS BUGS ChangeLog THANKS TODO doc/sample.wmclockmonrc
}
