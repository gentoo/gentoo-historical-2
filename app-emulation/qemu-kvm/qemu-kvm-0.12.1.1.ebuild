# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/qemu-kvm/qemu-kvm-0.12.1.1.ebuild,v 1.1 2009/12/22 13:51:33 tommy Exp $

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs linux-info

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

DESCRIPTION="QEMU + Kernel-based Virtual Machine userland tools"
HOMEPAGE="http://www.linux-kvm.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+aio alsa bluetooth curl esd gnutls fdt hardened kvm-trace ncurses \
pulseaudio sasl +sdl vde xen"

COMMON_TARGETS="i386 x86_64 arm cris m68k microblaze mips mipsel ppc ppc64 sh4 sh4eb sparc sparc64"

IUSE_SOFTMMU_TARGETS="${COMMON_TARGETS} mips64 mips64el ppcemb"
IUSE_USER_TARGETS="${COMMON_TARGETS} alpha armeb ppc64abi32 sparc32plus"

for target in ${IUSE_SOFTMMU_TARGETS}; do
	IUSE="${IUSE} +qemu_softmmu_targets_${target}"
done

for target in ${IUSE_USER_TARGETS}; do
	IUSE="${IUSE} +qemu_user_targets_${target}"
done

RESTRICT="test"

RDEPEND="sys-libs/zlib
	sys-apps/pciutils
	>=sys-apps/util-linux-2.16.0
	aio? ( dev-libs/libaio )
	alsa? ( >=media-libs/alsa-lib-1.0.13 )
	bluetooth? ( net-wireless/bluez )
	curl? ( net-misc/curl )
	esd? ( media-sound/esound )
	gnutls? ( net-libs/gnutls )
	fdt? ( sys-apps/dtc )
	ncurses? ( sys-libs/ncurses )
	pulseaudio? ( media-sound/pulseaudio )
	sasl? ( dev-libs/cyrus-sasl )
	sdl? ( >=media-libs/libsdl-1.2.11[X] )
	vde? ( net-misc/vde )
	!app-emulation/qemu-softmmu
	!app-emulation/qemu-user
	!app-emulation/qemu
	!app-emulation/kqemu"

DEPEND="${RDEPEND}
	app-text/texi2html
	>=sys-kernel/linux-headers-2.6.29
	gnutls? ( dev-util/pkgconfig )"

kvm_kern_war() {
	eerror "Please enable KVM support in your kernel, found at:"
	eerror
	eerror "  Virtualization"
	eerror "    Kernel-based Virtual Machine (KVM) support"
	eerror
}

pkg_setup() {
	if kernel_is lt 2 6 25; then
		eerror "This version of KVM requres a host kernel of 2.6.25 or higher."
		eerror "Either upgrade your kernel"
		die "qemu-kvm version not compatible"
	else
		if ! linux_config_exists; then
			eerror "Unable to check your kernel for KVM support"
			kvm_kern_warn
		elif ! linux_chkconfig_present KVM; then
			kvm_kern_warn
		fi
	fi

	enewgroup kvm
}

src_prepare() {
	# avoid fdt till an updated release appears
	sed -i -e 's:fdt="yes":fdt="no":' configure || die
	# prevent docs to get automatically installed
	sed -i '/$(DESTDIR)$(docdir)/d' Makefile || die
	# Alter target makefiles to accept CFLAGS set via flag-o
	sed -i 's/^\(C\|OP_C\|HELPER_C\)FLAGS=/\1FLAGS+=/' \
		Makefile Makefile.target || die
	# append CFLAGS while linking
	sed -i 's/$(LDFLAGS)/$(QEMU_CFLAGS) $(CFLAGS) $(LDFLAGS)/' rules.mak || die

	# remove part to make udev happy
	sed -e 's~NAME="%k", ~~' -i kvm/scripts/65-kvm.rules || die

	epatch "${FILESDIR}/qemu-0.11.0-mips64-user-fix.patch"
}

src_configure() {
	local conf_opts audio_opts softmmu_targets user_targets

	for target in ${IUSE_SOFTMMU_TARGETS} ; do
		use "qemu_softmmu_targets_${target}" && \
		softmmu_targets="${softmmu_targets} ${target}-softmmu"
	done

	for target in ${IUSE_USER_TARGETS} ; do
		use "qemu_user_targets_${target}" && \
		user_targets="${user_targets} ${target}-linux-user"
	done

	if [ ! -z "${softmmu_targets}" ]; then
		einfo "Building the following softmmu targets: ${softmmu_targets}"
	fi

	if [ ! -z "${user_targets}" ]; then
		einfo "Building the following user targets: ${user_targets}"
		conf_opts="${conf_opts} --enable-linux-user"
	else
		conf_opts="${conf_opts} --disable-linux-user"
	fi

	#config options
	conf_opts="${conf_opts} $(use_enable aio linux-aio)"
	use bluetooth || conf_opts="${conf_opts} --disable-bluez"
	conf_opts="${conf_opts} $(use_enable curl)"
	use gnutls || conf_opts="${conf_opts} --disable-vnc-tls"
	conf_opts="${conf_opts} $(use_enable fdt)"
	use hardened && conf_opts="${conf_opts} --enable-user-pie"
	use kvm-trace && conf_opts="${conf_opts} --with-kvm-trace"
	use ncurses || conf_opts="${conf_opts} --disable-curses"
	use sasl || conf_opts="${conf_opts} --disable-vnc-sasl"
	use sdl || conf_opts="${conf_opts} --disable-sdl"
	use vde || conf_opts="${conf_opts} --disable-vde"
	conf_opts="${conf_opts} $(use_enable xen)"
	conf_opts="${conf_opts} --disable-darwin-user --disable-bsd-user"

	# audio options
	audio_opts="oss"
	use alsa && audio_opts="alsa ${audio_opts}"
	use esd && audio_opts="esd ${audio_opts}"
	use pulseaudio && audio_opts="pa ${audio_opts}"
	use sdl && audio_opts="sdl ${audio_opts}"
	./configure --prefix=/usr \
		--disable-strip \
		--enable-kvm \
		--enable-nptl \
		--enable-uuid \
		${conf_opts} \
		--audio-drv-list="${audio_opts}" \
		--target-list="${softmmu_targets} ${user_targets}" \
		--cc=$(tc-getCC) \
		--host-cc=$(tc-getCC) \
		|| die "configure failed"

		# this is for qemu upstream's threaded support which is
		# in development and broken
		# the kvm project has its own support for threaded IO
		# which is always on and works
#		--enable-io-thread \
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	insinto /etc/udev/rules.d/
	doins kvm/scripts/65-kvm.rules || die

	insinto /etc/qemu/
	insopts -m0755
	doins kvm/scripts/qemu-ifup || die

	dodoc Changelog MAINTAINERS TODO pci-ids.txt || die
	newdoc pc-bios/README README.pc-bios || die
	dohtml qemu-doc.html qemu-tech.html || die

	dobin "${FILESDIR}"/qemu-kvm
	dosym /usr/bin/qemu-kvm /usr/bin/kvm
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
