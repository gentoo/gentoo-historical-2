# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-burn/vdr-burn-0.1.0_pre21-r4.ebuild,v 1.5 2008/12/31 03:31:27 mr_bones_ Exp $

inherit vdr-plugin eutils

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

S="${WORKDIR}/burn-${MY_PV}"

DESCRIPTION="VDR: DVD Burn Plugin"
HOMEPAGE="http://www.xeatre.de/community/burn"
SRC_URI="http://www.magoa.net/linux/contrib/${MY_P}.tgz"

KEYWORDS="~amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="projectx"

PATCHES=("${FILESDIR}/${PV}/i18n.diff"
	"${FILESDIR}/${PV}/menuburn.diff"
	"${FILESDIR}/${PV}/menuitems.diff"
	"${FILESDIR}/${PV}/${P}_setdefaults.diff"
	"${FILESDIR}/${PV}/${P}-gentoo.diff"
	"${FILESDIR}/${PV}/requantfactor.diff"
	"${FILESDIR}/${PV}/charset-vdr-1.5.diff"
	"${FILESDIR}/${PV}/${P}-gcc43.patch")

DEPEND=">=media-video/vdr-1.4
		>=dev-libs/libcdio-0.71
		>=dev-libs/boost-1.32.0
		media-libs/gd"

RDEPEND=">=media-video/dvdauthor-0.6.10
		>=media-video/mjpegtools-1.6.2
		>=media-video/vdrsync-0.1.3_pre1-r5
		>=media-video/m2vrequantizer-20060306
		media-video/transcode
		media-fonts/ttf-bitstream-vera
		media-video/vdrtools-genindex
		virtual/eject
		virtual/cdrtools
		>=app-cdr/dvd+rw-tools-5.21
		projectx? ( >=media-video/projectx-0.90.4.00-r4 )"

VDR_CONFD_FILE="${FILESDIR}/${PV}/confd"
VDR_RCADDON_FILE="${FILESDIR}/${PV}/rc-addon.sh"

pkg_setup() {
	local error=0

	if use projectx && [[ ! -d /usr/share/java-config-2 ]] ; then
		eerror
		eerror "ProjectX need an upgraded version of your Java install"
		eerror "Please upgrade your Java/Java-config install"
		eerror "\thttp://www.gentoo.org/proj/en/java/java-upgrade.xml"
		eerror
		error=1
	fi

	if ! built_with_use media-libs/gd png truetype jpeg ; then
		eerror
		eerror "Please recompile media-libs/gd with"
		eerror "USE=\"png truetype jpeg\""
		eerror
		error=1
	fi

	if ! built_with_use media-video/mjpegtools png ; then
		eerror
		eerror "Please recompile media-video/mjpegtools with"
		eerror "USE=\"png\""
		eerror
		error=1
	fi

	if [[ $error != 0 ]]; then
		die "Requirements not satisfied"
	fi

	vdr-plugin_pkg_setup
}

src_unpack() {
	vdr-plugin_src_unpack

	sed -i Makefile \
		-e 's#^TMPDIR = .*$#TMPDIR = /tmp#' \
		-e 's#^ISODIR=.*$#ISODIR=/var/vdr/video/dvd-images#'
}

src_install() {
	vdr-plugin_src_install

	dobin "${S}"/burn-buffers
	dobin "${S}"/*.sh

	insinto /usr/share/vdr/burn
	doins "${S}"/burn/menu-silence.mp2
	newins "${S}"/burn/menu-button.png menu-button-default.png
	newins "${S}"/burn/menu-bg.png menu-bg-default.png
	dosym menu-bg-default.png /usr/share/vdr/burn/menu-bg.png
	dosym menu-button-default.png /usr/share/vdr/burn/menu-button.png

	use projectx && newins "${S}"/burn/ProjectX.ini projectx-vdr.ini

	fowners -R vdr:vdr /usr/share/vdr/burn

	(
		diropts -ovdr -gvdr
		keepdir /usr/share/vdr/burn/counters
	)
}

pkg_preinst() {
	if [[ -d ${ROOT}/etc/vdr/plugins/burn && ( ! -L ${ROOT}/etc/vdr/plugins/burn ) ]]; then
		einfo "Moving /etc/vdr/plugins/burn away"
		mv "${ROOT}"/etc/vdr/plugins/burn "${ROOT}"/etc/vdr/plugins/burn_old
	fi
}

pkg_postinst() {

	local DMH_FILE="${ROOT}/usr/share/vdr/burn/counters/standard"
	if [[ ! -e "${DMH_FILE}" ]]; then
		echo 0001 > "${DMH_FILE}"
		chown vdr:vdr "${DMH_FILE}"
	fi

	vdr-plugin_pkg_postinst

	einfo
	einfo "This ebuild comes only with the standard template"
	einfo "'emerge vdr-burn-templates' for more templates"
	einfo "To change the templates, use the vdr-image plugin"

	if [[ -e ${ROOT}/etc/vdr/reccmds/reccmds.burn.conf ]]; then
		eerror
		eerror "Please remove the following unneeded file:"
		eerror "\t/etc/vdr/reccmds/reccmds.burn.conf"
		eerror
	fi
}
