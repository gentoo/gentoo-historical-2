# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/zynaddsubfx/zynaddsubfx-1.4.3.ebuild,v 1.9 2004/12/29 02:57:43 ribosome Exp $

inherit eutils

MY_P=ZynAddSubFX-${PV}
DESCRIPTION="ZynAddSubFX is a opensource software synthesizer."
HOMEPAGE="http://zynaddsubfx.sourceforge.net/"
SRC_URI="mirror://sourceforge/zynaddsubfx/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE=""

DEPEND=">=x11-libs/fltk-1.1.2
	=sci-libs/fftw-2*
	media-sound/jack-audio-connection-kit"

S="${WORKDIR}/${MY_P}"

src_compile() {
	# patched to enable jack and fix compile scripts for
	# spliter and controller
	epatch ${FILESDIR}/${P}.patch
	cd ${S}/src
	make || die "compile failed"
	cd ${S}/ExternalPrograms/Spliter
	./compile.sh
	cd ${S}/ExternalPrograms/Controller
	./compile.sh
}

src_install() {
	dobin ${S}/src/zynaddsubfx
	dobin ${S}/ExternalPrograms/Spliter/spliter
	dobin ${S}/ExternalPrograms/Controller/controller
	dodoc COPYING FAQ.txt README.txt HISTORY.txt
	dodir /usr/share/${PN}
	cp -r ${S}/examples/* ${D}/usr/share/${PN}
}
