# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/cups-pdf/cups-pdf-2.2.0.ebuild,v 1.2 2006/05/08 22:43:58 genstef Exp $

inherit toolchain-funcs multilib

DESCRIPTION="Provides a virtual printer for CUPS to produce PDF files."
HOMEPAGE="http://cip.physik.uni-wuerzburg.de/~vrbehr/cups-pdf/"
SRC_URI="http://cip.physik.uni-wuerzburg.de/~vrbehr/cups-pdf/src/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="net-print/cups
	virtual/ghostscript"

src_compile() {
	cd src
	$(tc-getCC) ${CFLAGS} -o cups-pdf cups-pdf.c || die "Compilation failed."
}

src_install () {
	has_version =net-print/cups-1.2* \
		&& exeinto /usr/libexec/cups/backend \
		|| exeinto /usr/$(get_libdir)/cups/backend
	doexe src/cups-pdf

	insinto /usr/share/cups/model
	doins extra/PostscriptColor.ppd.gz

	insinto /etc/cups
	doins extra/cups-pdf.conf

	dodoc ChangeLog README
}
