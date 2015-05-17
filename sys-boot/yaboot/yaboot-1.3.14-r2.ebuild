# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/yaboot/yaboot-1.3.14-r2.ebuild,v 1.7 2015/05/17 04:16:27 vapier Exp $

inherit eutils toolchain-funcs

DESCRIPTION="PPC Bootloader"
SRC_URI="http://yaboot.ozlabs.org/releases/${P}.tar.gz"
HOMEPAGE="http://yaboot.ozlabs.org"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* ppc -ppc64"
IUSE="ibm"

DEPEND="sys-apps/powerpc-utils"
RDEPEND="!ibm? ( sys-fs/hfsutils
				 sys-fs/hfsplusutils
				 sys-fs/mac-fdisk )"

src_compile() {
	unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS

	# No need to hardcode this path -- the compiler already knows to use it.
	sed -i \
		-e 's:-I/usr/include::' \
		Makefile || die

	# dual boot patch
	epatch "${FILESDIR}/yabootconfig-1.3.13.patch"
	epatch "${FILESDIR}/chrpfix.patch"
	if [[ "$(gcc-major-version)" -eq "3" ]]; then
		epatch "${FILESDIR}/yaboot-nopiessp.patch"
	fi
	if [[ "$(gcc-major-version)" -eq "4" ]]; then
		epatch "${FILESDIR}/yaboot-nopiessp-gcc4.patch"
	fi
	epatch "${FILESDIR}/sysfs-ofpath.patch"
	emake PREFIX=/usr MANDIR=share/man CC="$(tc-getCC)" LD="$(tc-getLD)" || die
}

src_install() {
	cp etc/yaboot.conf etc/yaboot.conf.bak
	sed -e 's/\/local//' etc/yaboot.conf >| etc/yaboot.conf.edit
	mv -f etc/yaboot.conf.edit etc/yaboot.conf
	make ROOT="${D}" PREFIX=/usr MANDIR=share/man install || die
}
