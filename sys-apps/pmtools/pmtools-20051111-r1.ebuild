# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pmtools/pmtools-20051111-r1.ebuild,v 1.1 2006/06/02 02:35:36 robbat2 Exp $

inherit eutils toolchain-funcs

DESCRIPTION="ACPI disassembler tools, including acpidump"
HOMEPAGE="http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/"
SRC_URI="http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/utils/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~amd64 ~x86"
IUSE=""
DEPEND="virtual/libc"
RDEPEND="${DEPEND}
		dev-lang/perl
		>=sys-power/iasl-20060512"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-madt.patch
	epatch ${FILESDIR}/${P}-acpixtract-pmtools.patch
	sed -i.orig \
		-e '/^CFLAGS/s, -s , ,' \
		${S}/acpidump/Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	# acpidump access the ACPI data via /dev/mem or EFI firmware in /sys
	dosbin acpidump/acpidump
	# the other tools only process data
	newbin acpidump/acpixtract acpixtract-pmtools
	dobin acpidump/acpitbl
	dobin madt/madt

	dodoc README
	docinto madt
	dodoc madt/README madt/APIC*
}

pkg_postinst() {
	ewarn "Please note that acpixtract is now named acpixtract-pmtools to avoid"
	ewarn "conflicts with the new tool of the same name from the iasl package."
}
