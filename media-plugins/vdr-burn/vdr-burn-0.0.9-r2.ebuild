# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-burn/vdr-burn-0.0.9-r2.ebuild,v 1.1 2006/03/05 21:01:00 hd_brummy Exp $

inherit vdr-plugin

MY_PV="0.0.009"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="DVD Burn Plugin"
HOMEPAGE="http://www.xeatre.de/community/burn"
SRC_URI="http://vdr.unetz.com/download/burn/${MY_P}.tgz"

KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.2.6
		>=media-video/vdrsync-0.1.3_pre1-r5
		>=media-libs/imlib2-1.1.2
		>=media-video/requant-0.0.1
		>=media-video/transcode-0.6.11
		>=media-video/dvdauthor-0.6.10
		>=app-cdr/dvd+rw-tools-5.20
		>=media-video/mjpegtools-1.6.2
		>=media-gfx/imagemagick-6.1.3.2"

S="${WORKDIR}/burn-${MY_PV}"

PATCHES="${FILESDIR}/${P}-gentoo.diff"

src_install() {
	vdr-plugin_src_install

	dobin ${S}/scripts/*.sh

	insinto /usr/share/vdr/burn
	doins ${S}/burn/{*.png,*.ttf,*.mp2}

	insinto /etc/vdr/reccmds
	doins ${FILESDIR}/reccmds.burn.conf
}

pkg_preinst() {

	if [[ -L ${ROOT}/etc/vdr/plugins/burn ]]; then
		einfo "remove unneeded link /etc/vdr/plugins/burn"
		einfo "from prior install"
		unlink ${ROOT}/etc/vdr/plugins/burn
	fi
}

pkg_postinst() {
	vdr-plugin_src_install

	echo
	einfo "This ebuild comes only with the standard template"
	einfo "'emerge vdr-burn-templates' for more templates"
	einfo "To change the templates, use the vdr-image plugin"
	echo
}

