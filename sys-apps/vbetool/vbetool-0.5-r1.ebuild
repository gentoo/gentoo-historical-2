# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/vbetool/vbetool-0.5-r1.ebuild,v 1.1 2006/05/18 18:39:01 robbat2 Exp $

inherit eutils

DESCRIPTION="Run real-mode video BIOS code to alter hardware state (i.e. reinitialize video card)"
HOMEPAGE="http://www.srcf.ucam.org/~mjg59/vbetool/"
#SRC_URI="${HOMEPAGE}${PN}_${PV}.orig.tar.gz"
#SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${P//-/_}-1.tar.gz"
SRC_URI="http://www.srcf.ucam.org/~mjg59/${PN}/${P//-/_}-1.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RDEPEND="sys-apps/pciutils"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-0.4"

#src_unpack() {
#	unpack ${A}
#	epatch ${FILESDIR}/${P}-pci-compile-fix.patch
#}

src_compile() {
	# when on non-x86 machines, we need to use the x86 emulator
	LIBS="-lpci" econf `use_with !x86 x86emu` || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "install failed"
	dodoc LRMI
}
