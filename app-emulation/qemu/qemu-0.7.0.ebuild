# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/qemu/qemu-0.7.0.ebuild,v 1.6 2005/05/12 09:13:55 lu_zero Exp $

inherit eutils flag-o-matic linux-mod toolchain-funcs

DESCRIPTION="Multi-platform & multi-targets cpu emulator and dynamic translator"
HOMEPAGE="http://fabrice.bellard.free.fr/qemu/"
SRC_URI="http://fabrice.bellard.free.fr/qemu/${P}.tar.gz
	kqemu? ( http://fabrice.bellard.free.fr/qemu/kqemu-0.6.2-1.tar.gz )"
#qvm86? ( http://dev.gentoo.org/~lu_zero/distfiles/qvm86-20050409.tar.bz2 )"
#kqemu? ( http://fabrice.bellard.free.fr/qemu/kqemu-${PV%.*}-1.tar.gz )

LICENSE="GPL-2 LGPL-2.1 KQEMU"
SLOT="0"
KEYWORDS="~x86 ~ppc -alpha -sparc ~amd64"
IUSE="softmmu sdl kqemu"  #qvm86 debug nptl qemu-fast nptlonly"
RESTRICT="nostrip"

DEPEND="virtual/libc
	sdl? ( media-libs/libsdl )
	app-text/texi2html"
RDEPEND="sdl? ( media-libs/libsdl )"

MODULE_NAMES=""
use kqemu && MODULE_NAMES=$MODULE_NAMES" kqemu(misc:${S}/kqemu)"
#use qvm86 && MODULE_NAMES=$MODULE_NAMES" qvm86(misc:${S}/qvm86)"

set_target_list() {
	TARGET_LIST="arm-user armeb-user i386-user ppc-user sparc-user"
	use softmmu &&
		TARGET_LIST="${TARGET_LIST} i386-softmmu ppc-softmmu sparc-softmmu x86_64-softmmu"
	export TARGET_LIST
}

pkg_setup() {
	if [ "$(gcc-major-version)" == "4" ]; then
		ewarn "Qemu could not build with GCC 4"
	fi
#	( use kqemu || use qvm86 ) && linux-mod_pkg_setup
	use kqemu && linux-mod_pkg_setup
}

#RUNTIME_PATH="/emul/gnemul/"
src_unpack() {
	unpack ${A}

	if use kqemu ; then
	einfo "QEMU Accelerator enabled"
	einfo "kqemu actually is a closed source software"
	einfo "Please read carefully the KQEMU license"
	einfo "and http://fabrice.bellard.free.fr/qemu/qemu-accel.html"
	einfo "if you want it released under GPL"
	mv ${S}/../kqemu ${S}
	cd ${S}/kqemu
	epatch ${FILESDIR}/kqemu-sysfs.patch
	fi

#	if use qvm86; then
#		mv ${WORKDIR}/qvm86 ${S}
#		cd ${S}
#		epatch qvm86/patch.qvm86
#	fi
	cd ${S}
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

	myconf=""
	set_target_list
#		--interp-prefix=${RUNTIME_PATH}/qemu-%M
	./configure \
		--prefix=/usr \
		--target-list="${TARGET_LIST}" \
		--enable-slirp \
		--kernel-path=${KV_DIR} \
		$(use_enable kqemu) \
		${myconf} \
		$(use_enable sdl)\
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

	if use kqemu ; then

		linux-mod_src_install

		# udev rule
		dodir /etc/udev/rules.d/
		echo 'KERNEL="kqemu*",           NAME="%k", GROUP="qemu", MODE="0660"' \
			> ${D}/etc/udev/rules.d/48-qemu.rules
		enewgroup qemu

		# Module doc
		dodoc ${S}/kqemu/README

	fi
}

pkg_postinst() {
	einfo "You will need the Universal TUN/TAP driver compiled into"
	einfo "kernel or as a module to use the virtual network device."
	if ! use softmmu ; then
		ewarn ""
		ewarn "You have the softmmu useflag disabled."
		ewarn "In order to have the full system emulator (qemu) you have"
		ewarn "to emerge qemu again with the softmmu useflag enabled."
		ewarn ""
	fi
	if use kqemu ; then
		einfo "kqemu actually is a closed source software"
		einfo "Please read carefully the KQEMU license"
		einfo "and http://fabrice.bellard.free.fr/qemu/qemu-accel.html"
		einfo "if you want it released under GPL"
		linux-mod_pkg_postinst
		einfo "make sure you have the kernel module loaded before running qemu"
	fi
}
