# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/subtitleripper/subtitleripper-0.3.4-r3.ebuild,v 1.7 2008/12/26 11:49:13 armin76 Exp $

inherit versionator eutils

MY_PV="$(replace_version_separator 2 "-")"

DESCRIPTION="DVD Subtitle Ripper for Linux"
HOMEPAGE="http://subtitleripper.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~ppc64 sparc x86"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_PV}.tgz"
SLOT="0"
IUSE=""
RDEPEND=">=media-libs/netpbm-10.41.0
	media-libs/libpng
	sys-libs/zlib
	>=app-text/gocr-0.39"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# PPM library is libnetppm
	sed -i -e "s:ppm:netpbm:g" Makefile
	# fix for bug 210435
	sed -i -e "s:#include <ppm.h>:#include <netpbm/ppm.h>:g" spudec.c subtitle2pgm.c
	# we will install the gocrfilters into /usr/share/subtitleripper
	sed -i -e 's:~/sourceforge/subtitleripper/src/:/usr/share/subtitleripper:' pgm2txt

	epatch "${FILESDIR}/${P}-linkingorder.patch"
}

src_install () {
	dobin pgm2txt srttool subtitle2pgm subtitle2vobsub vobsub2pgm

	insinto /usr/share/subtitleripper
	doins gocrfilter_*.sed

	dodoc ChangeLog README*
}
