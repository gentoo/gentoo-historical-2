# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/v4l-dvb-hg/v4l-dvb-hg-0.1.ebuild,v 1.1 2006/05/21 17:02:22 zzam Exp $


: ${EHG_REPO_URI:=http://linuxtv.org/hg/v4l-dvb}

inherit linux-mod eutils toolchain-funcs mercurial

DESCRIPTION="live development version of v4l&dvb-driver for Kernel 2.6"
SRC_URI=""
HOMEPAGE="http://www.linuxtv.org"

KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="virtual/linux-sources"
RDEPEND=""

S=${WORKDIR}/v4l-dvb/v4l

pkg_setup()
{
	linux-mod_pkg_setup
	if [[ "${KV_MAJOR}.${KV_MINOR}" != "2.6"  ]]; then
		ewarn "other Kernel than 2.6.x are not supported at the moment."
		die "unsupported Kernel (not 2.6.x)"
	fi
	MODULE_NAMES="dvb(dvb:${S})"
	BUILD_PARAMS="KDIR=${KERNEL_DIR}"
	BUILD_TARGETS="default"
}

src_unpack() {
	# download and copy files
	S=${WORKDIR}/v4l-dvb mercurial_src_unpack

	cd ${WORKDIR}
	epatch ${FILESDIR}/${PN}-fix-makefile-recursion.diff

	cd ${S}

	export ARCH=$(tc-arch-kernel)
	make allmodconfig ${BUILD_PARAMS}
	export ARCH=$(tc-arch)

	# apply local patches
	if test -n "${DVB_LOCAL_PATCHES}";
	then
		ewarn "Applying local patches:"
		for LOCALPATCH in ${DVB_LOCAL_PATCHES};
		do
			if test -f "${LOCALPATCH}";
			then
				if grep -q linux/drivers ${LOCALPATCH}; then
					cd ${S}/..
				else
					cd ${S}
				fi
				epatch ${LOCALPATCH}
			fi
		done
	else
		einfo "No additional local patches to use"
	fi
	echo

	cd ${S}
	sed -e 's#/lib/modules/$(KERNELRELEASE)/kernel/drivers/media#$(DESTDIR)/$(DEST)#' \
		-e '/-install::/s:rminstall::' \
		-i Makefile
	sed -e '/depmod/d' -i Makefile*
}

src_install() {
	# install the modules
	make install DESTDIR="${D}" \
		DEST="/lib/modules/${KV_FULL}/v4l-dvb" \
	|| die "make install failed"

	cd ${S}/..
	dodoc linux/Documentation/dvb/*.txt
	dosbin linux/Documentation/dvb/get_dvb_firmware
}

pkg_postinst() {
	einfo
	einfo "Firmware-files can be found in media-tv/linuxtv-dvb-firmware"
	einfo

	linux-mod_pkg_postinst
	einfo
	einfo
	einfo "if you want to use the IR-port or networking"
	einfo "with the dvb-card you need to"
	einfo "install linuxtv-dvb-apps"
	einfo
}
