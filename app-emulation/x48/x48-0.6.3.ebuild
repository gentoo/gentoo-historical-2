# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/x48/x48-0.6.3.ebuild,v 1.1 2011/01/30 19:47:27 flameeyes Exp $

EAPI=3

inherit eutils autotools

DESCRIPTION="HP48 Calculator Emulator"
HOMEPAGE="http://x48.berlios.de/"
SRC_URI="mirror://berlios/x48/${P}.tar.gz"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="readline"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	readline? ( sys-libs/readline )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	x11-libs/libXt"

src_prepare() {
	epatch "${FILESDIR}/${P}-off-by-one.patch"
	epatch "${FILESDIR}/${P}-no-readline.patch"
	eautoreconf
}

src_configure() {
	econf $(use_enable readline)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed."
	dodoc AUTHORS README ChangeLog
}

pkg_postinst() {
	elog "The X48 emulator requires an HP48 ROM image to run."
	elog
	elog "If you own an HP-48 calculator, you can use the ROMDump utility"
	elog "included with this package to obtain this from your calculator."
	elog
	elog "Alternatively, HP has provided the ROM images for non-commercial"
	elog "use only."
	elog
	elog "Due to confusion over the legal status of these ROMs you must"
	elog "manually download one from http://www.hpcalc.org/hp48/pc/emulators/"
	elog
	elog "If you do not know which one to use, try 'HP 48GX Revision R ROM.'"
	elog
	elog "Once you have a ROM, you will need to install it by running:"
	elog
	elog "x48 -rom gxrom-r"
	elog
	elog "You will only have to do this the first time you run X48. The"
	elog "ROM will be stored in ~/.hp48/rom for future runs."
}
