# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gerbv/gerbv-2.4.0.ebuild,v 1.2 2010/05/21 15:10:10 pva Exp $

EAPI="2"

inherit fdo-mime

DESCRIPTION="A RS-274X (Gerber) and NC drill (Excellon) file viewer"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://gerbv.sourceforge.net/"

IUSE="unit-mm doc examples"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~sparc ~x86"
RESTRICT="test"

RDEPEND=">=x11-libs/gtk+-2.4
	>=x11-libs/cairo-1.2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

src_configure() {
	econf \
		$(use_enable unit-mm) \
		--disable-dependency-tracking \
		--disable-update-desktop-database
}

src_install () {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog CONTRIBUTORS HACKING NEWS README* TODO BUGS

	rm doc/Doxyfile.nopreprocessing
	if use doc; then
		find doc -name "Makefile*" -exec rm -f '{}' \;
		find doc -name "*.txt" -exec ecompress '{}' \;
		insinto /usr/share/doc/${PF}
		doins -r doc/*
	fi

	if use examples; then
		find example -name "Makefile*" -exec rm -f '{}' \;
		find example -name "*.txt" -exec ecompress '{}' \;
		insinto /usr/share/doc/${PF}/examples
		doins -r example/*
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
