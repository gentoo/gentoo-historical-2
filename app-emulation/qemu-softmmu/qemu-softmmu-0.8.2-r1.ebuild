# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/qemu-softmmu/qemu-softmmu-0.8.2-r1.ebuild,v 1.5 2006/12/31 12:59:23 vapier Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Multi-platform & multi-targets cpu emulator and dynamic translator"
HOMEPAGE="http://fabrice.bellard.free.fr/qemu/"
SRC_URI="${HOMEPAGE}${P/-softmmu/}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 KQEMU"
SLOT="0"
KEYWORDS="-alpha ~amd64 ppc -sparc ~x86"
IUSE="sdl kqemu alsa"  #qvm86 debug nptl qemu-fast nptlonly"
RESTRICT="nostrip test"

DEPEND="virtual/libc
	sdl? ( media-libs/libsdl )
	alsa? ( media-libs/alsa-lib )
	!<=app-emulation/qemu-0.7.0
	kqemu? ( >=app-emulation/kqemu-1.3.0_pre7 )
	app-text/texi2html"
RDEPEND="sdl? ( media-libs/libsdl )"

S="${WORKDIR}/${P/-softmmu/}"

QA_TEXTRELS="usr/bin/qemu
	usr/bin/qemu-system-sparc
	usr/bin/qemu-system-arm
	usr/bin/qemu-system-ppc
	usr/bin/qemu-system-mips
	usr/bin/qemu-system-x86_64"
QA_EXECSTACK="usr/share/qemu/openbios-sparc32"
QA_WX_LOAD="usr/share/qemu/openbios-sparc32"

set_target_list() {
	TARGET_LIST="i386-softmmu ppc-softmmu sparc-softmmu x86_64-softmmu arm-softmmu mips-softmmu"
	export TARGET_LIST
}

pkg_setup() {
	if [ "$(gcc-major-version)" == "4" ]; then
		eerror "qemu requires gcc-3 in order to build and work correctly"
		eerror "please compile it with gcc-3"
		die "gcc 4 cannot build qemu"
	fi
}

#RUNTIME_PATH="/emul/gnemul/"
src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/qemu-${PV}-linux-headers.patch
	epatch "${FILESDIR}"/qemu-${PV}-sparc-fp.patch
	# Alter target makefiles to accept CFLAGS set via flag-o.
	sed -i 's/^\(C\|OP_C\|HELPER_C\)FLAGS=/\1FLAGS+=/' \
		Makefile Makefile.target tests/Makefile
	# Ensure mprotect restrictions are relaxed for emulator binaries
	[[ -x /sbin/paxctl ]] && \
		sed -i 's/^VL_LDFLAGS=$/VL_LDFLAGS=-Wl,-z,execheap/' \
			Makefile.target
	# Prevent install of kernel module by qemu's makefile
	sed -i 's/\(.\/install.sh\)/#\1/' Makefile
}

src_compile() {
	#Let the application set its cflags
	unset CFLAGS

	# Switch off hardened tech
	filter-flags -fpie -fstack-protector

	set_target_list

	myconf="--disable-gcc-check"
	if ! use sdl ; then
		myconf="$myconf --disable-gfx-check"
	fi
	./configure \
		--prefix=/usr \
		--target-list="${TARGET_LIST}" \
		--enable-slirp --enable-adlib \
		--cc=$(tc-getCC) \
		--host-cc=$(tc-getCC) \
		--kernel-path=${KV_DIR} \
		$(use_enable sdl)\
		$(use_enable kqemu) \
		$(use_enable alsa) \
		${myconf} \
		|| die "could not configure"

	emake || die "make failed"
}

src_install() {
	make install \
		prefix=${D}/usr \
		bindir=${D}/usr/bin \
		datadir=${D}/usr/share/qemu \
		docdir=${D}/usr/share/doc/${P} \
		mandir=${D}/usr/share/man || die

	chmod -x ${D}/usr/share/man/*/*
}

pkg_postinst() {
	einfo "You will need the Universal TUN/TAP driver compiled into"
	einfo "kernel or as a module to use the virtual network device."
}
