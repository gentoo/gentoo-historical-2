# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/debianutils/debianutils-2.28.2.ebuild,v 1.3 2008/01/23 07:28:22 vapier Exp $

inherit eutils flag-o-matic

DESCRIPTION="A selection of tools from Debian"
HOMEPAGE="http://packages.debian.org/unstable/utils/debianutils"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ia64 m68k ~mips ~ppc ~ppc64 s390 sh sparc x86"
IUSE="static"

PDEPEND="sys-apps/mktemp"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-2.28.2-no-bs-namespace.patch
	epatch "${FILESDIR}"/${PN}-2.16.2-palo.patch
}

src_compile() {
	use static && append-ldflags -static
	econf || die
	emake || die
}

src_install() {
	into /
	dobin tempfile run-parts || die
	dosbin installkernel || die "installkernel failed"

	into /usr
	dosbin savelog mkboot || die "savelog/mkboot failed"

	doman tempfile.1 run-parts.8 savelog.8 installkernel.8 mkboot.8
	cd debian
	dodoc changelog control
}
