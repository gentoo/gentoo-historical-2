# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-base/x11-drm/x11-drm-20060608.ebuild,v 1.2 2006/06/16 07:09:43 battousai Exp $

inherit eutils x11 linux-mod

IUSE_VIDEO_CARDS="
	video_cards_i810
	video_cards_mach64
	video_cards_mga
	video_cards_nv
	video_cards_r128
	video_cards_radeon
	video_cards_savage
	video_cards_sis
	video_cards_sunffb
	video_cards_tdfx
	video_cards_via"
IUSE="${IUSE_VIDEO_CARDS}"

# Make sure Portage does _NOT_ strip symbols.  We will do it later and make sure
# that only we only strip stuff that are safe to strip ...
RESTRICT="nostrip"

S="${WORKDIR}/drm"
PATCHVER="0.1"
PATCHDIR="${WORKDIR}/patch"
EXCLUDED="${WORKDIR}/excluded"

DESCRIPTION="DRM Kernel Modules for X11"
HOMEPAGE="http://dri.sf.net"
SRC_URI="mirror://gentoo/${P}-gentoo-${PATCHVER}.tar.bz2
	 mirror://gentoo/linux-drm-${PV}-kernelsource.tar.bz2"

SLOT="0"
LICENSE="X11"
KEYWORDS="~x86 ~alpha ~ia64 ~ppc ~amd64"

DEPEND=">=sys-devel/automake-1.7
	>=sys-devel/autoconf-2.59
	>=sys-devel/libtool-1.5.14
	>=sys-devel/m4-1.4
	virtual/linux-sources
	>=sys-apps/portage-2.0.49-r13"

pkg_setup() {
	get_version

	if is_kernel 2 6
	then
		if linux_chkconfig_builtin "DRM"
		then
			die "Please disable or modularize DRM in the kernel config. (CONFIG_DRM = n or m)"
		fi

		if ! linux_chkconfig_present "AGP"
		then
			einfo "AGP support is not enabled in your kernel config. This may be needed for DRM to"
			einfo "work, so you might want to double-check that setting. (CONFIG_AGP)"
			echo
		fi
	elif is_kernel 2 4
	then
		if ! linux_chkconfig_present "DRM"
		then
			die "Please enable DRM support in your kernel configuration. (CONFIG_DRM = y or m)."
			echo
		fi
	fi

	# Set video cards to build for.
	set_vidcards

	# DRM CVS is undergoing changes which require splitting source to support both 2.4
	# and 2.6 kernels. This determines which to use.
	get_drm_build_dir

	return 0
}

src_unpack() {
	unpack linux-drm-${PV}-kernelsource.tar.bz2
	unpack ${P}-gentoo-${PATCHVER}.tar.bz2

	cd ${S}

	patch_prepare

	# Apply patches
	EPATCH_SUFFIX="patch" epatch ${PATCHDIR}

	# Substitute new directory under /lib/modules/${KV_FULL}
	cd ${SRC_BUILD}
	sed -ie "s:/kernel/drivers/char/drm:/${PN}:g" Makefile

	cp ${S}/tests/*.c ${SRC_BUILD}

	cd ${S}
	WANT_AUTOCONF="2.59" WANT_AUTOMAKE="1.7" autoreconf -v --install
}

src_compile() {
	einfo "Building DRM in ${SRC_BUILD}..."
	cd ${SRC_BUILD}

	# This now uses an M= build system. Makefile does most of the work.
	unset ARCH
	make M="${SRC_BUILD}" \
		LINUXDIR="${KERNEL_DIR}" \
		DRM_MODULES="${VIDCARDS}" \
		modules || die_error

	# Building the programs. These are useful for developers and getting info from DRI and DRM.
	#
	# libdrm objects are needed for drmstat.
	cd ${S}
	econf || die "libdrm configure failed."
	emake || die "libdrm build failed."

	if linux_chkconfig_present DRM
	then
		echo "Please disable in-kernel DRM support to use this package."
	fi

	cd ${SRC_BUILD}
	# LINUXDIR is needed to allow Makefiles to find kernel release.
	make LINUXDIR="${KERNEL_DIR}" dristat || die "Building dristat failed."
	make LINUXDIR="${KERNEL_DIR}" drmstat || die "Building drmstat failed."
}

src_install() {
	einfo "Installing DRM..."
	cd ${SRC_BUILD}

	unset ARCH
	is_kernel 2 6 && DRM_KMOD="drm.${KV_OBJ}"
	make KV="${KV_FULL}" \
		LINUXDIR="${KERNEL_DIR}" \
		DESTDIR="${D}" \
		RUNNING_REL="${KV_FULL}" \
		MODULE_LIST="${VIDCARDS} ${DRM_KMOD}" \
		install || die "Install failed."

	dodoc README.drm

	dobin dristat
	dobin drmstat

	# Strip binaries, leaving /lib/modules untouched (bug #24415)
	strip_bins \/lib\/modules

	# Yoinked from the sys-apps/touchpad ebuild. Thanks to whoever made this.
	keepdir /etc/modules.d
	sed 's:%PN%:'${PN}':g' ${FILESDIR}/modules.d-${PN} > ${D}/etc/modules.d/${PN}
	sed -i 's:%KV%:'${KV_FULL}':g' ${D}/etc/modules.d/${PN}
}

pkg_postinst() {
	if use video_cards_sis
	then
		einfo "SiS direct rendering only works on 300 series chipsets."
		einfo "SiS framebuffer also needs to be enabled in the kernel."
	fi

	if use video_cards_mach64
	then
		einfo "The Mach64 DRI driver is insecure."
		einfo "Malicious clients can write to system memory."
		einfo "For more information, see:"
		einfo "http://dri.freedesktop.org/wiki/ATIMach64."
	fi

	einfo "Checking kernel module dependencies"
	update_modules
	update_depmod
}

# Functions used above are defined below:

set_vidcards() {
	set_kvobj

	POSSIBLE_VIDCARDS="mga tdfx r128 radeon i810 i830 i915 mach64 nv savage
		sis via"
	if use sparc; then
		POSSIBLE_VIDCARDS="${POSSIBLE_VIDCARDS} ffb"
	fi
	VIDCARDS=""

	if [[ -n "${VIDEO_CARDS}" ]]; then
		use video_cards_i810 && \
			VIDCARDS="${VIDCARDS} i810.${KV_OBJ} i830.${KV_OBJ} i915.${KV_OBJ}"
		use video_cards_mach64 && \
			VIDCARDS="${VIDCARDS} mach64.${KV_OBJ}"
		use video_cards_mga && \
			VIDCARDS="${VIDCARDS} mga.${KV_OBJ}"
		use video_cards_nv && \
			VIDCARDS="${VIDCARDS} nv.${KV_OBJ}"
		use video_cards_r128 && \
			VIDCARDS="${VIDCARDS} r128.${KV_OBJ}"
		use video_cards_radeon && \
			VIDCARDS="${VIDCARDS} radeon.${KV_OBJ}"
		use video_cards_savage && \
			VIDCARDS="${VIDCARDS} savage.${KV_OBJ}"
		use video_cards_sis && \
			VIDCARDS="${VIDCARDS} sis.${KV_OBJ}"
		use video_cards_via && \
			VIDCARDS="${VIDCARDS} via.${KV_OBJ}"
		use video_cards_sunffb && \
			VIDCARDS="${VIDCARDS} ffb.${KV_OBJ}"
		use video_cards_tdfx && \
			VIDCARDS="${VIDCARDS} tdfx.${KV_OBJ}"
	else
		for card in ${POSSIBLE_VIDCARDS}; do
			VIDCARDS="${VIDCARDS} ${card}.${KV_OBJ}"
		done
	fi
}

patch_prepare() {
	# Handle exclusions based on the following...
	#     All trees (0**), Standard only (1**), Others (none right now)
	#     2.4 vs. 2.6 kernels

	kernel_is 2 4 && mv -f ${PATCHDIR}/*kernel-2.6* ${EXCLUDED}
	kernel_is 2 6 && mv -f ${PATCHDIR}/*kernel-2.4* ${EXCLUDED}

	# There is only one tree being maintained now. No numeric exclusions need
	# to be done based on DRM tree.
}

die_error() {
	eerror "Portage could not build the DRM modules. If you see an ACCESS DENIED error,"
	eerror "this could mean that you were using an unsupported kernel build system. All"
	eerror "2.4 kernels are supported, but only 2.6 kernels at least as new as 2.6.6"
	eerror "are supported."
	die "Unable to build DRM modules."
}

get_drm_build_dir() {
	if kernel_is 2 4
	then
		SRC_BUILD="${S}/linux"
	elif kernel_is 2 6
	then
		SRC_BUILD="${S}/linux-core"
	fi
}
