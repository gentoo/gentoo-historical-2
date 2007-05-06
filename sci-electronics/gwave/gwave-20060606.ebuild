# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gwave/gwave-20060606.ebuild,v 1.1 2007/05/06 15:56:43 calchan Exp $

inherit flag-o-matic

DESCRIPTION="Analog waveform viewer for SPICE-like simulations"
LICENSE="GPL-2"
HOMEPAGE="http://www.geda.seul.org/tools/gwave/"
SRC_URI="http://www.geda.seul.org/dist/${P}.tar.gz"

KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gnuplot plotutils"
SLOT="0"

DEPEND="=dev-scheme/guile-1.6*
	=x11-libs/guile-gtk-1.2*"
RDEPEND="${DEPEND}
	gnuplot? ( sci-visualization/gnuplot )
	plotutils? ( media-libs/plotutils )"

src_compile() {
	filter-ldflags -Wl,--as-needed --as-needed
	econf --disable-dependency-tracking || die "Configuration failed"
	make || die "Compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	rm -f doc/Makefile* *.1 || die "Removing doc/Makefile failed"
	dodoc AUTHORS NEWS README TODO doc/* || die "Installation of documentation failed"
}
