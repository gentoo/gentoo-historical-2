# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/gentoo-vdr-scripts/gentoo-vdr-scripts-0.3.5.ebuild,v 1.1 2006/06/16 13:18:27 zzam Exp $

inherit eutils

IUSE="nvram"

SRC_URI="mirror://gentoo/${P}.tar.bz2"
DESCRIPTION="scripts necessary for use of vdr as a set-top-box"
HOMEPAGE="http://www.gentoo.org/"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="nvram? ( x86? ( sys-power/nvram-wakeup ) )
		app-admin/sudo"

VDR_HOME=/var/vdr

pkg_setup() {
	enewgroup vdr
	enewuser vdr -1 /bin/bash ${VDR_HOME} vdr,video,audio,cdrom
}

src_install() {
	local myopts=""
	if use nvram; then
		if use x86; then
			myopts="${myopts} NVRAM=1"
		else
			ewarn "nvram-wakeup is not available on this architecture."
		fi
	fi

	make install DESTDIR="${D}" ${myopts} || die "make install failed"
	dodoc README TODO ChangeLog


	keepdir /var/vdr/shutdown-data
	keepdir /var/vdr/merged-config-files
	keepdir /var/vdr/dvd-images

	local MAKE_VIDEO_DIR=1
	local testd
	for testd in video0 video00 video.0 video.00; do
		[[ -d ${ROOT}/var/vdr/${testd} ]] && MAKE_VIDEO_DIR=0
	done
	if [[ ${MAKE_VIDEO_DIR} == 1 ]]; then
		keepdir /var/vdr/video
	fi

	chown vdr:vdr -R ${D}/var/vdr
}

pkg_preinst() {
	local owner
	local d
	for d in /etc/vdr /var/vdr; do
		if [[ -d ${d} ]]; then
			owner=$(stat ${d} -c "%U")
			if [[ ${owner} != vdr ]]; then
				einfo "Changing ownership of ${d}"
				chown -R vdr:vdr ${d}
			fi
		fi
	done
}

VDRSUDOENTRY="vdr ALL=NOPASSWD:/usr/lib/vdr/bin/vdrshutdown-really.sh"

pkg_postinst() {
	einfo
	einfo "To make shutdown work add this line to /etc/sudoers"
	einfo "    $VDRSUDOENTRY"
	einfo
	einfo "or execute this command:"
	einfo "    emerge --config gentoo-vdr-scripts"
	einfo
	ewarn "The default video directory was moved to /var/vdr/video"
	ewarn "If you have your video directory anywhere else, then"
	ewarn "change the setting VIDEO in the file /etc/conf.d/vdr."
	ewarn
	if use x86 && use !nvram; then
		ewarn "nvram wakeup is now optional."
		ewarn "To make use of it enable the use flag nvram."
	fi
}

pkg_config() {
	if grep -q /usr/lib/vdr/bin/vdrshutdown-really.sh ${ROOT}/etc/sudoers; then
		einfo "sudoers-entry for vdr already in place."
	else
		einfo "Adding this line to /etc/sudoers:"
		einfo "+  ${VDRSUDOENTRY}"

		cd ${T}
		cat >sudoedit-vdr.sh <<-SUDOEDITOR
			#!/bin/bash
			echo "" >> \${1}
			echo "${VDRSUDOENTRY}" >> \${1}
		SUDOEDITOR
		chmod a+x sudoedit-vdr.sh

		VISUAL=${T}/sudoedit-vdr.sh visudo -f ${ROOT}/etc/sudoers || die "visudo failed"

		einfo "Edited /etc/sudoers"
	fi
}

