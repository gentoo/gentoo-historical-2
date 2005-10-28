# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/nvidia-kernel/nvidia-kernel-1.0.6629-r4.ebuild,v 1.5 2005/10/28 07:19:45 eradicator Exp $

inherit eutils linux-mod

X86_PKG_V="pkg1"
AMD64_PKG_V="pkg2"
NV_V="${PV/1.0./1.0-}"
X86_NV_PACKAGE="NVIDIA-Linux-x86-${NV_V}"
AMD64_NV_PACKAGE="NVIDIA-Linux-x86_64-${NV_V}"

DESCRIPTION="Linux kernel module for the NVIDIA X11 driver"
HOMEPAGE="http://www.nvidia.com/"
SRC_URI="x86? ( ftp://download.nvidia.com/XFree86/Linux-x86/${NV_V}/${X86_NV_PACKAGE}-${X86_PKG_V}.run )
	amd64? ( http://download.nvidia.com/XFree86/Linux-x86_64/${NV_V}/${AMD64_NV_PACKAGE}-${AMD64_PKG_V}.run )"

if use x86; then
	PKG_V="${X86_PKG_V}"
	NV_PACKAGE="${X86_NV_PACKAGE}"
elif use amd64; then
	PKG_V="${AMD64_PKG_V}"
	NV_PACKAGE="${AMD64_NV_PACKAGE}"
fi

S="${WORKDIR}/${NV_PACKAGE}-${PKG_V}/usr/src/nv"

LICENSE="NVIDIA"
SLOT="0"
KEYWORDS="-* x86 amd64"
RESTRICT="nostrip"
IUSE=""

RDEPEND="virtual/modutils"
DEPEND="virtual/linux-sources"
export _POSIX2_VERSION="199209"

MODULE_NAMES="nvidia(video:${S})"
BUILD_PARAMS="IGNORE_CC_MISMATCH=yes V=1 SYSSRC=${KV_DIR} SYSOUT=${KV_OUT_DIR}"

mtrr_check() {
	ebegin "Checking for MTRR support"
	linux_chkconfig_present MTRR
	eend $?

	if [ "$?" != 0 ]
	then
		eerror "This version needs MTRR support for most chipsets!"
		eerror "Please enable MTRR support in your kernel config, found at:"
		eerror
		eerror "  Processor type and features"
		eerror "    [*] MTRR (Memory Type Range Register) support"
		eerror
		eerror "and recompile your kernel ..."
		die "MTRR support not detected!"
	fi
}

pkg_setup() {
	linux-mod_pkg_setup
	mtrr_check;
}

src_unpack() {
	if [ ${KV_MINOR} -ge 6 -a ${KV_PATCH} -lt 7 ]
	then
		echo
		ewarn "Your kernel version is ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}"
		ewarn "This is not officially supported for ${P}. It is likely you"
		ewarn "will not be able to compile or use the kernel module."
		ewarn "It is recommended that you upgrade your kernel to a version >= 2.6.7"
		echo
		ewarn "DO NOT file bug reports for kernel versions less than 2.6.7 as they will be ignored."
	fi

	cd ${WORKDIR}
	bash ${DISTDIR}/${NV_PACKAGE}-${PKG_V}.run --extract-only

	# Add patches below, with a breif description.
	cd ${S}
	# Any general patches should go here
	# Shutup pointer arith warnings
	use x86 && epatch ${FILESDIR}/${PV}/nv-shutup-warnings.patch
	use amd64 && epatch ${FILESDIR}/${PV}/nv-amd64-shutup-warnings.patch

	# Patches from Zander (http://www.minion.de/files/1.0-6629/)
	epatch ${FILESDIR}/${PV}/NVIDIA_kernel-1.0-6629-1155389.patch
	#epatch ${FILESDIR}/${PV}/NVIDIA_kernel-1.0-6629-1162524.patch
	epatch ${FILESDIR}/${PV}/NVIDIA_kernel-1.0-6629-1165235.patch
	epatch ${FILESDIR}/${PV}/NVIDIA_kernel-1.0-6629-1171869.patch
	epatch ${FILESDIR}/${PV}/NVIDIA_kernel-1.0-6629-1175225.patch
	epatch ${FILESDIR}/${PV}/NVIDIA_kernel-1.0-6629-1182399.patch
	epatch ${FILESDIR}/${PV}/NVIDIA_kernel-1.0-6629-1189413.patch
	epatch ${FILESDIR}/${PV}/NVIDIA_kernel-1.0-6629-1201042.diff

	# Now any patches specific to the 2.6 kernel should go here
	if kernel_is 2 6
	then
		einfo "Applying 2.6 kernel patches"
		# Fix the /usr/src/linux/include/asm not existing on koutput issue #58294
		epatch ${FILESDIR}/${PV}/conftest_koutput_includes.patch
		# Fix calling of smp_processor_id() when preempt is enabled
		epatch ${FILESDIR}/${PV}/nv-disable-preempt-on-smp_processor_id.patch
		# Fix a limitation on available video memory bug #71684
		epatch ${FILESDIR}/${PV}/NVIDIA_kernel-1.0-6629-1161283.patch
		# New multi-agp support with newer -mm kernels
		# http://lkml.org/lkml/2005/1/25/349
		[[ -n $(grep agp_bridge_data "${KV_DIR}/include/linux/agp_backend.h") ]] && \
			epatch ${FILESDIR}/${PV}/NVIDIA_kernel-1.0-6629-agp_bridge_data.patch
	fi

	# if you set this then it's your own fault when stuff breaks :)
	[ -n "${USE_CRAZY_OPTS}" ] && sed -i "s:-O:${CFLAGS}:" Makefile.*

	# if greater than 2.6.5 use M= instead of SUBDIR=
	convert_to_m ${S}/Makefile.kbuild
}

src_install() {
	linux-mod_src_install

	# Add the aliases
	sed -e 's:\${PACKAGE}:'${PF}':g' ${FILESDIR}/nvidia > ${WORKDIR}/nvidia
	insinto /etc/modules.d
	newins ${WORKDIR}/nvidia nvidia

	# Docs
	dodoc ${S}/../../share/doc/README

	# The device creation script
	into /
	newsbin ${S}/makedevices.sh NVmakedevices.sh
}

pkg_postinst() {
	if [ "${ROOT}" = "/" ] && \
		[ ! -e /dev/.devfsd ] && \
		[ ! -e /dev/.udev ] && \
		[ -x /sbin/NVmakedevices.sh ]
	then
		/sbin/NVmakedevices.sh >/dev/null 2>&1
	fi

	linux-mod_pkg_postinst
}
