# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/kvm/kvm-72.ebuild,v 1.1 2008/08/04 21:08:00 dang Exp $

inherit eutils flag-o-matic toolchain-funcs linux-mod

# Patchset git repo is at http://github.com/dang/kvm-patches/tree/master
PATCHSET="kvm-patches-20080716"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/${PATCHSET}.tar.gz"

DESCRIPTION="Kernel-based Virtual Machine userland tools"
HOMEPAGE="http://kvm.qumranet.com/kvmwiki"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
# Add bios back when it builds again
IUSE="alsa esd gnutls havekernel ncurses pulseaudio sdl test"
RESTRICT="test"

RDEPEND="sys-libs/zlib
	alsa? ( >=media-libs/alsa-lib-1.0.13 )
	esd? ( media-sound/esound )
	pulseaudio? ( media-sound/pulseaudio )
	gnutls? ( net-libs/gnutls )
	ncurses? ( sys-libs/ncurses )
	sdl? ( >=media-libs/libsdl-1.2.11 )"

#    bios? (
#        sys-devel/dev86
#        dev-lang/perl
#        sys-power/iasl
#    )
DEPEND="${RDEPEND}
	gnutls? ( dev-util/pkgconfig )
	app-text/texi2html"

QA_TEXTRELS="usr/bin/kvm"

pkg_setup() {
	# check kernel version
	if use havekernel ; then
		ewarn "You have the 'havekernel' use flag set.  This means you"
		ewarn "must ensure you have a compatible kernel on your own."
	elif kernel_is lt 2 6 22; then
		eerror "the kvm in your kernel requires an older version of"
		eerror "kvm as shown in :"
		eerror "  http://kvm.qumranet.com/kvmwiki/Downloads"
		die "kvm version not compatible"
	fi

	# check for kvm support
	if use havekernel ; then
		ewarn "You have the 'havekernel' use flag set.  This means you"
		ewarn "must ensure your kernel has KVM support enable on your own"
	elif ! linux_chkconfig_present KVM; then
		eerror "Please enable KVM support in your kernel, found at:"
		eerror
		eerror "  Virtualization"
		eerror "    Kernel-based Virtual Machine (KVM) support"
		die "KVM support not detected!"
	fi

	enewgroup kvm
}

src_unpack() {
	unpack ${A}

	cd "${S}"
	# prevent docs to get automatically installed
	sed -i '/$(DESTDIR)$(docdir)/d' qemu/Makefile
	# Alter target makefiles to accept CFLAGS set via flag-o
	sed -i 's/^\(C\|OP_C\|HELPER_C\)FLAGS=/\1FLAGS+=/' \
		qemu/Makefile qemu/Makefile.target
	[[ -x /sbin/paxctl ]] && \
		sed -i 's/^VL_LDFLAGS=$/VL_LDFLAGS=-Wl,-z,execheap/' \
			qemu/Makefile.target
	# avoid strip
	sed -i 's/$(INSTALL) -m 755 -s/$(INSTALL) -m 755/' qemu/Makefile

	epatch \
		"${WORKDIR}/${PATCHSET}"/kvm-45-qemu-configure.patch \
		"${WORKDIR}/${PATCHSET}"/kvm-61-qemu-kvm.patch \
		"${WORKDIR}/${PATCHSET}"/kvm-57-qemu-kvm-cmdline.patch \
		"${WORKDIR}/${PATCHSET}"/kvm-57-kernel-longmode.patch \
		"${WORKDIR}/${PATCHSET}"/kvm-68-libkvm-no-kernel.patch \
		"${WORKDIR}/${PATCHSET}"/kvm-69-qemu-no-blobs.patch \
		"${WORKDIR}/${PATCHSET}"/kvm-69-qemu-ifup_ifdown.patch \
		"${WORKDIR}/${PATCHSET}"/kvm-70-block-rw-range-check.patch \
		"${WORKDIR}/${PATCHSET}"/kvm-71-qemu-kvm-doc.patch \
		"${WORKDIR}/${PATCHSET}"/kvm-71-qemu-configure.patch
}

src_compile() {
	local mycc conf_opts audio_opts

	audio_opts="oss"
	use gnutls || conf_opts="$conf_opts --disable-vnc-tls"
	use ncurses || conf_opts="$conf_opts --disable-curses"
	use sdl || conf_opts="$conf_opts --disable-gfx-check --disable-sdl"
	use alsa && audio_opts="alsa $audio_opts"
	use esd && audio_opts="esd $audio_opts"
	use pulseaudio && audio_opts="pa $audio_opts"
	use sdl && audio_opts="sdl $audio_opts"
	conf_opts="$conf_opts --disable-gcc-check"
	conf_opts="$conf_opts --prefix=/usr"
	#conf_opts="$conf_opts --audio-drv-list=\"$audio_opts\""

	./configure ${conf_opts} --audio-drv-list="$audio_opts" || die "econf failed"

	emake libkvm || die "emake libkvm failed"

	if use test; then
		emake user || die "emake user failed"
	fi

	mycc=$(cat qemu/config-host.mak | egrep "^CC=" | cut -d "=" -f 2)

	filter-flags -fpie -fstack-protector

	# If using gentoo's compiler set the SPEC to non-hardened
	if [ ! -z ${GCC_SPECS} -a -f ${GCC_SPECS} ]; then
		local myccver=$(${mycc} -dumpversion)
		local gccver=$($(tc-getBUILD_CC) -dumpversion)

		#Is this a SPEC for the right compiler version?
		myspec="${GCC_SPECS/${gccver}/${myccver}}"
		if [ "${myspec}" == "${GCC_SPECS}" ]; then
			shopt -s extglob
			GCC_SPECS="${GCC_SPECS/%hardened*specs/vanilla.specs}"
			shopt -u extglob
		else
			unset GCC_SPECS
		fi
	fi

#    if use bios; then
#        emake bios || die "emake bios failed"
#        emake vgabios || die "emake vgabios failed"
#    fi

	emake qemu || die "emake qemu failed"
}

src_install() {
	# kcmd so we don't install kernel modules which weren't build
	emake DESTDIR="${D}" kcmd='#' install || die "make install failed"

	exeinto /usr/bin/
	doexe "${S}/kvm_stat"

	mv "${D}"/usr/share/man/man1/qemu.1 "${D}"/usr/share/man/man1/kvm.1
	mv "${D}"/usr/share/man/man1/qemu-img.1 "${D}"/usr/share/man/man1/kvm-img.1
	mv "${D}"/usr/share/man/man8/qemu-nbd.8 "${D}"/usr/share/man/man8/kvm-nbd.8
	mv "${D}"/usr/bin/qemu-img "${D}"/usr/bin/kvm-img
	mv "${D}"/usr/bin/qemu-nbd "${D}"/usr/bin/kvm-nbd

	insinto /etc/udev/rules.d/
	doins scripts/65-kvm.rules

	insinto /etc/kvm/
	insopts -m0755
	newins scripts/qemu-ifup kvm-ifup
	newins scripts/qemu-ifdown kvm-ifdown

	dodoc qemu/pc-bios/README
	newdoc qemu/qemu-doc.html kvm-doc.html
	newdoc qemu/qemu-tech.html kvm-tech.html
}

pkg_postinst() {
	elog "If you don't have kvm compiled into the kernel, make sure you have"
	elog "the kernel module loaded before running kvm. The easiest way to"
	elog "ensure that the kernel module is loaded is to load it on boot."
	elog "For AMD CPUs the module is called 'kvm-amd'"
	elog "For Intel CPUs the module is called 'kvm-intel'"
	elog "Please review /etc/conf.d/modules for how to load these"
	elog
	elog "Make sure your user is in the 'kvm' group"
	elog "Just run 'gpasswd -a <USER> kvm', then have <USER> re-login."
	elog
	elog "You will need the Universal TUN/TAP driver compiled into your"
	elog "kernel or loaded as a module to use the virtual network device"
	elog "if using -net tap.  You will also need support for 802.1d"
	elog "Ethernet Bridging and a configured bridge if using the provided"
	elog "kvm-ifup script from /etc/kvm."
	echo
}
