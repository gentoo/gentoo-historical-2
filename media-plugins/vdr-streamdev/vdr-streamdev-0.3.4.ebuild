# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-streamdev/vdr-streamdev-0.3.4.ebuild,v 1.2 2008/06/21 19:48:00 hd_brummy Exp $

inherit vdr-plugin eutils

DESCRIPTION="Video Disk Recorder Client/Server streaming plugin"
HOMEPAGE="http://www.magoa.net/linux/"
SRC_URI="http://streamdev.vdr-developer.org/releases/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.3.24
	!media-plugins/vdr-streamdev-client
	!media-plugins/vdr-streamdev-server"

EXTERNREMUX_PATH=/usr/share/vdr/streamdev/externremux.sh

PATCHES=("${FILESDIR}/${P}-gentoo.diff")

src_unpack() {
	vdr-plugin_src_unpack
	cd "${S}"

	# Moving externremux.sh out of /root
	sed -i remux/extern.c \
		-e "s#/root/externremux.sh#${EXTERNREMUX_PATH}#"

	# make subdir libdvbmpeg respect CXXFLAGS
	sed -i Makefile \
		-e '/CXXFLAGS.*+=/s:^:#:'
	sed -i libdvbmpeg/Makefile \
		-e 's:CFLAGS =  -g -Wall -O2:CFLAGS = $(CXXFLAGS) :'

	fix_vdr_libsi_include server/livestreamer.c
}

src_install() {
	vdr-plugin_src_install

	cd "${S}"
	insinto /etc/vdr/plugins/streamdev
	newins streamdevhosts.conf.example streamdevhosts.conf
	chown vdr:vdr "${D}"/etc/vdr -R
}

pkg_postinst() {
	echo
	elog "To activate the client part for this vdr-plugin execute the following command:"
	elog "\teselect vdr-plugin enable ${PN#vdr-}-client"
	elog
	echo
	elog "To activate the server part for this vdr-plugin execute the following command:"
	elog "\teselect vdr-plugin enable ${PN#vdr-}-server"
	elog
	echo
	elog "If you want to use the externremux-feature, then put"
	elog "your custom script as ${EXTERNREMUX_PATH}."

	if [[ -e "${ROOT}"/etc/vdr/plugins/streamdevhosts.conf ]]; then
		einfo "move config file to new config DIR ${ROOT}/etc/vdr/plugins/streamdev/"
		mv "${ROOT}"/etc/vdr/plugins/streamdevhosts.conf "${ROOT}"/etc/vdr/plugins/streamdev/streamdevhosts.conf
	fi
}
