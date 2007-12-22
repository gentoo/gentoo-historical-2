# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gtkwave/gtkwave-3.1.1.ebuild,v 1.5 2007/12/22 17:05:22 dertobi123 Exp $

DOC_VERSION="3.1.0"
DESCRIPTION="A wave viewer for LXT, LXT2, VZT, GHW and standard Verilog VCD/EVCD files"
HOMEPAGE="http://home.nc.rr.com/gtkwave/"
SRC_URI="http://home.nc.rr.com/gtkwave/${P}.tar.gz
	doc? ( http://home.nc.rr.com/gtkwave/${PN}-doc-${DOC_VERSION}.tar.gz )"

IUSE="doc examples"
LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

DEPEND=">=x11-libs/gtk+-2
	dev-util/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	dodoc ANALOG_README.TXT CHANGELOG.TXT
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins "${WORKDIR}/${PN}.pdf" || die "Failed to install documentation."
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die "Failed to install examples."
	fi
}
