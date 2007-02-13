# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pciutils/pciutils-2.2.4.ebuild,v 1.3 2007/02/13 15:15:51 gustavoz Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Various utilities dealing with the PCI bus"
HOMEPAGE="http://atrey.karlin.mff.cuni.cz/~mj/pciutils.html"
SRC_URI="ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-2.2.3-build.patch
	epatch "${FILESDIR}"/pcimodules-${PN}-2.2.4.patch
	epatch "${FILESDIR}"/${P}-link.patch #160421
}

src_compile() {
	tc-export AR CC RANLIB
	emake OPT="${CFLAGS}" || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die

	dolib lib/libpci.* || die "libpci failed"
	insinto /usr/include/pci
	doins lib/{config,header,pci,types}.h || die "headers failed"

	exeinto /etc/cron.monthly
	newexe "${FILESDIR}"/pciutils.cron update-pciids || die
}
