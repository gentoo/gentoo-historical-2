# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ifd-gempc/ifd-gempc-1.0.3.ebuild,v 1.2 2007/11/11 06:25:53 alonbl Exp $

inherit eutils toolchain-funcs

DESCRIPTION="GemCore based PC/SC reader drivers for pcsc-lite"
HOMEPAGE="http://ludovic.rousseau.free.fr/softwares/ifd-GemPC"
LICENSE="GPL-2 BSD"
KEYWORDS="~ppc ~x86"
SLOT="0"
SRC_URI="http://ludovic.rousseau.free.fr/softwares/ifd-GemPC/${P}.tar.gz"
IUSE=""
RDEPEND=">=sys-apps/pcsc-lite-1.2.9_beta5
	>=dev-libs/libusb-0.1.10a"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install () {
	local pcscdir="$(pkg-config --variable=usbdropdir libpcsclite)"
	local conf="/etc/reader.conf.d/${PN}.conf"
	emake install CC="$(tc-getCC)" DESTDIR="${D}" || die
	dodoc README*
	dodir "$(dirname "${conf}")"
	insinto "$(dirname "${conf}")"
	newins "${FILESDIR}/reader.conf" "$(basename "${conf}")"
	sed -i "s#%PCSC_DRIVERS_DIR%#${pcscdir}#g" "${D}/${conf}"

	einfo "NOTICE:"
	einfo "1. if you are using GemPC410 modify ${conf}"
	einfo "2. run update-reader.conf, yes this is a command..."
	einfo "3. restart pcscd"
}

pkg_postrm() {
	#
	# Without this, pcscd will not start next time.
	#
	local conf="/etc/reader.conf.d/${PN}.conf"
	if ! [ -f "$(grep LIBPATH "${conf}" | sed 's/LIBPATH *//' | sed 's/ *$//g' | head -n 1)" ]; then
		rm "${conf}"
		update-reader.conf
		einfo "NOTICE:"
		einfo "You need to restart pcscd"
	fi
}
