# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/xcopilot/xcopilot-0.6.6.ebuild,v 1.9 2007/07/22 09:41:41 omp Exp $

MY_P="xcopilot-0.6.6-uc0"

DESCRIPTION="A pilot emulator"
HOMEPAGE="http://www.uclinux.org/"
SRC_URI="http://www.uclinux.org/pub/uClinux/utilities/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXt
	x11-libs/libXpm
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXdmcp"

DEPEND="app-arch/dpkg
	x11-proto/xextproto
	x11-proto/xproto"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf --disable-autorun || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS README NEWS README.uClinux
}

pkg_postinst() {
	elog "See /usr/share/doc/${PF}/README.uClinux for more info"
}
