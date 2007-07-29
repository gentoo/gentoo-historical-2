# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/gallery/gallery-1.5.3.ebuild,v 1.9 2007/07/29 17:27:25 phreak Exp $

inherit webapp

DESCRIPTION="Web based (PHP Script) photo album viewer/creator"
HOMEPAGE="http://gallery.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE="imagemagick netpbm unzip zip"

RDEPEND=">=www-servers/apache-2.0
	virtual/php
	media-libs/jpeg
	netpbm? ( >=media-libs/netpbm-9.12 >=media-gfx/jhead-2.2 )
	imagemagick? ( >=media-gfx/imagemagick-5.4.9.1-r1 )
	unzip? ( app-arch/unzip )
	zip? ( app-arch/zip )"

S=${WORKDIR}/${PN}

src_install() {
	webapp_src_preinst

	cp -R * ${D}/${MY_HTDOCSDIR}
	for file in AUTHORS ChangeLog README ChangeLog.archive.gz; do
		dodoc ${file}
		rm -f ${D}/${MY_HTDOCSDIR}/${file}
	done
	dohtml docs/*

	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}
