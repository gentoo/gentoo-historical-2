# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/gxemul/gxemul-0.4.5.1.ebuild,v 1.2 2007/07/22 09:22:47 omp Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A Machine Emulator, Mainly emulates MIPS, but supports other CPU types."
HOMEPAGE="http://gavare.se/gxemul/"
SRC_URI="http://gavare.se/gxemul/src/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="X"

RDEPEND="X? ( x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXdmcp )"

DEPEND="${RDEPEND}
	X? ( x11-proto/xproto )"

src_compile() {
	tc-export CC
	local myconf=""

	use X || myconf="${myconf} --disable-x"

	einfo "Configuring with: ${myconf}"
	./configure ${myconf} || die "configure failed"

	emake || die "emake failed"
}

src_install() {
	dobin gxemul || die "gxemul not found in ${S}"
	doman man/gxemul.1
	dodoc HISTORY LICENSE README RELEASE TODO
	dohtml doc/*
}
