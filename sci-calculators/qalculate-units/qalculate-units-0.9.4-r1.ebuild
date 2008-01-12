# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/qalculate-units/qalculate-units-0.9.4-r1.ebuild,v 1.3 2008/01/12 12:18:14 markusle Exp $

DESCRIPTION="A GTK+ unit conversion tool"
LICENSE="GPL-2"
HOMEPAGE="http://qalculate.sourceforge.net/"
SRC_URI="mirror://sourceforge/qalculate/${P}.tar.gz"

SLOT="0"
IUSE="nls"
KEYWORDS="~amd64 ~x86"

DEPEND=">=sci-libs/libqalculate-0.9.4
	>=x11-libs/gtk+-2.4
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_compile() {
	econf --disable-clntest || die "Configuration failed."
	emake || die "Compilation failed."
}

src_install() {
	make install DESTDIR="${D}" || die "Installation failed."
	dodoc AUTHORS ChangeLog README || die "Failed to install documentation."
}
