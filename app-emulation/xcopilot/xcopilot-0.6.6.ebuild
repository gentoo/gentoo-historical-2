# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/xcopilot/xcopilot-0.6.6.ebuild,v 1.5 2005/01/01 14:21:13 eradicator Exp $

MY_P="xcopilot-0.6.6-uc0"

DESCRIPTION="A pilot emulator"
HOMEPAGE="http://www.uclinux.org/"
SRC_URI="http://www.uclinux.org/pub/uClinux/utilities/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="virtual/libc
	virtual/x11
	app-arch/dpkg"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf --disable-autorun || die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS README NEWS README.uClinux
}

pkg_postinst() {
	einfo "See /usr/share/doc/${PF}/README.uClinux for more info"
}
