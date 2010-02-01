# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/qalculate-currency/qalculate-currency-0.9.4-r2.ebuild,v 1.3 2010/02/01 22:45:08 fauli Exp $

inherit autotools

DESCRIPTION="A GTK+ currency converter"
LICENSE="GPL-2"
HOMEPAGE="http://qalculate.sourceforge.net/"
SRC_URI="mirror://sourceforge/qalculate/${P}.tar.gz"

SLOT="0"
IUSE="nls"
KEYWORDS="~amd64 x86"

RDEPEND=">=sci-libs/libqalculate-0.9.6-r1
	>=x11-libs/gtk+-2.4
	nls? ( sys-devel/gettext )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-cln-config.patch
	eautoconf
}

src_compile() {
	econf --disable-clntest || die "Configuration failed."
	emake || die "Compilation failed."
}

src_install() {
	make install DESTDIR="${D}" || die "Installation failed."
	dodoc AUTHORS ChangeLog README || die "Failed to install documentation."
}
