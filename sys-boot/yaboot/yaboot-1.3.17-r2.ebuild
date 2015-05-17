# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/yaboot/yaboot-1.3.17-r2.ebuild,v 1.6 2015/05/17 04:18:20 vapier Exp $

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="PPC Bootloader"
SRC_URI="http://yaboot.ozlabs.org/releases/${P}.tar.gz"
HOMEPAGE="http://yaboot.ozlabs.org"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* ppc -ppc64"
IUSE="ibm"

DEPEND="sys-apps/powerpc-utils
	sys-fs/e2fsprogs[static-libs]"
RDEPEND="!sys-boot/yaboot-static
	!ibm? (
		sys-fs/hfsutils
		sys-fs/hfsplusutils
		sys-fs/mac-fdisk
	)"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}/new-ofpath" "${S}/ybin/ofpath"
}

src_prepare() {
	# No need to hardcode this path -- the compiler already knows to use it.
	sed -i \
		-e 's:-I/usr/include::' \
		Makefile || die

	# dual boot patch
	epatch "${FILESDIR}/yabootconfig-1.3.13.patch"
	epatch "${FILESDIR}/chrpfix.patch"
	if [[ "$(gcc-major-version)" -eq "3" ]]; then
		epatch "${FILESDIR}/${PN}-nopiessp.patch"
	fi
	if [[ "$(gcc-major-version)" -eq "4" ]]; then
		epatch "${FILESDIR}/${P}-nopiessp-gcc4.patch"
	fi

	# Error only on real errors, for prom printing format compile failure
	sed -i "s:-Werror:-Wno-error:g" Makefile

	# Stub out some functions that are not provided (and unneeded)
	epatch "${FILESDIR}/${PN}-stubfuncs.patch"

	# Fix the devspec path on newer kernels
	epatch "${FILESDIR}/new-ofpath-devspec.patch"
}

src_compile() {
	unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
	emake PREFIX=/usr MANDIR=share/man CC="$(tc-getCC)" LD="$(tc-getLD)" || die
}

src_install() {
	sed -i -e 's/\/local//' etc/yaboot.conf
	make ROOT="${D}" PREFIX=/usr MANDIR=share/man install || die
	mv "${D}/etc/yaboot.conf" "${D}/etc/yaboot.conf.sample"
}
