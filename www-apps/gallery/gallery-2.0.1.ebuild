# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/gallery/gallery-2.0.1.ebuild,v 1.1 2005/10/23 19:33:02 rl03 Exp $

inherit webapp

DESCRIPTION="Web based (PHP Script) photo album viewer/creator"
HOMEPAGE="http://gallery.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-full.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="ffmpeg gd imagemagick netpbm mysql postgres"

RDEPEND="virtual/httpd-php
	>=media-gfx/jhead-2.2
	app-arch/unzip
	media-libs/jpeg
	ffmpeg? ( media-video/ffmpeg )
	gd? ( >=media-libs/gd-2 )
	netpbm? ( >=media-libs/netpbm-9.12 )
	imagemagick? ( >=media-gfx/imagemagick-5.4.9.1-r1 )
	mysql? ( dev-db/mysql )
	postgres? ( >=dev-db/postgresql-7 )
"

S=${WORKDIR}/${PN}2

src_install() {
	webapp_src_preinst

	cp -R * ${D}/${MY_HTDOCSDIR}
	dohtml README.html

	webapp_postinst_txt en ${FILESDIR}/postinstall-en2.txt
	webapp_src_install
}
