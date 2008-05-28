# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/thaifonts-scalable/thaifonts-scalable-0.4.10.ebuild,v 1.2 2008/05/28 07:02:51 loki_val Exp $

inherit font

DESCRIPTION="A collection of Free fonts for Thai"
HOMEPAGE="http://linux.thai.net/projects/thaifonts-scalable"
SRC_URI="ftp://linux.thai.net/pub/thailinux/software/thai-ttf/thai-ttf-${PV}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/thai-ttf-${PV}"
FONT_S="${S}"
FONT_SUFFIX="ttf"

FONT_CONF=(	"${FONT_S}/etc/fonts/conf.avail/65-ttf-thai-tlwg.conf"
		"${FONT_S}/etc/fonts/conf.avail/90-ttf-thai-tlwg-synthetic.conf" )

pkg_postinst() {
	elog "This font package comes with config files for fontconfig."
	elog "To enable basic support for this font, do:"
	elog "eselect fontconfig enable 65-ttf-thai-tlwg.conf"
	elog "To make this font emulate the thai font of windows, do:"
	elog "eselect fontconfig enable 90-ttf-thai-tlwg-synthetic.conf"
	font_pkg_postinst
}

DOCS=""
