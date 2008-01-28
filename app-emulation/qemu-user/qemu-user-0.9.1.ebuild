# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/qemu-user/qemu-user-0.9.1.ebuild,v 1.2 2008/01/28 09:56:06 lu_zero Exp $

inherit eutils flag-o-matic

DESCRIPTION="Multi-platform & multi-targets cpu emulator and dynamic translator"
HOMEPAGE="http://fabrice.bellard.free.fr/qemu/"
SRC_URI="http://fabrice.bellard.free.fr/qemu/${P/-user/}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""  #qvm86 debug nptl qemu-fast nptlonly"
RESTRICT="strip test"

DEPEND="virtual/libc
	app-text/texi2html
	!<=app-emulation/qemu-0.7.0"
RDEPEND=""

S="${WORKDIR}/${P/-user/}"

QA_TEXTRELS="usr/bin/qemu-armeb
	usr/bin/qemu-i386
	usr/bin/qemu-mips
	usr/bin/qemu-arm
	usr/bin/qemu-ppc"

#RUNTIME_PATH="/emul/gnemul/"
src_unpack() {
	unpack ${A}

	cd "${S}"

	# Alter target makefiles to accept CFLAGS set via flag-o.
	sed -i 's/^\(C\|OP_C\|HELPER_C\)FLAGS=/\1FLAGS+=/' \
		Makefile Makefile.target tests/Makefile
	# Ensure mprotect restrictions are relaxed for emulator binaries
	[[ -x /sbin/paxctl ]] && \
		sed -i 's/^VL_LDFLAGS=$/VL_LDFLAGS=-Wl,-z,execheap/' \
			Makefile.target
	# Prevent install of kernel module by qemu's makefile
	sed -i 's/\(.\/install.sh\)/#\1/' Makefile
	# avoid strip
	sed -i 's:$(INSTALL) -m 755 -s:$(INSTALL) -m 755:' Makefile Makefile.target
}

src_compile() {
	#Let the application set its cflags
	unset CFLAGS

	# Switch off hardened tech
	filter-flags -fpie -fstack-protector

	myconf="--disable-gcc-check"
	./configure \
		--prefix=/usr \
		--enable-linux-user \
		--disable-system \
		${myconf} \
		|| die "could not configure"

	emake || die "make failed"
}

src_install() {
	einstall docdir="${D}/usr/share/doc/${P}" || die

	rm -fR "${D}/usr/share/{man,qemu}"
	rm -fR "${D}/usr/bin/qemu-img"
}
