# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/gallery/gallery-2.1.1a.ebuild,v 1.3 2006/07/09 21:55:17 rl03 Exp $

inherit webapp eutils depend.php

DESCRIPTION="Web based (PHP Script) photo album viewer/creator"
HOMEPAGE="http://gallery.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-full.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="dcraw ffmpeg gd imagemagick mysql netpbm postgres unzip zip"

RDEPEND="virtual/httpd-php
	media-libs/jpeg
	dcraw? ( >=media-gfx/dcraw-8.03 )
	ffmpeg? ( >=media-video/ffmpeg-0.4.9_p20051216 )
	gd? ( >=media-libs/gd-2 )
	imagemagick? ( >=media-gfx/imagemagick-5.4.9.1-r1 )
	mysql? ( dev-db/mysql )
	netpbm? ( >=media-libs/netpbm-9.12 >=media-gfx/jhead-2.2 )
	postgres? ( >=dev-db/postgresql-7 )
	unzip? ( app-arch/unzip )
	zip? ( app-arch/zip )
"

S=${WORKDIR}/${PN}2

pkg_setup() {
	webapp_pkg_setup

	local php_flags="session"

	use gd && php_flags="${php_flags} gd"
	use mysql && php_flags="${php_flags} mysql"
	use postgres && php_flags="${php_flags} postgres"

	require_php_with_use ${php_flags}
}

src_install() {
	webapp_src_preinst

	cp -R * ${D}/${MY_HTDOCSDIR}
	dohtml README.html

	webapp_postinst_txt en ${FILESDIR}/postinstall-en2.txt
	webapp_src_install
}

pkg_postinst() {
	elog "You are strongly encouraged to back up your database"
	elog "and the g2data directory, as upgrading to 2.1.x will make"
	elog "irreversible changes to both."
	elog
	elog "g2data dir: cp -Rf /path/to/g2data/ /path/to/backup"
	elog "mysql: mysqldump --opt -u username -h hostname -p database > /path/to/backup.sql"
	elog "postgres: pg_dump -h hostname --format=t database > /path/to/backup.sql"
	webapp_pkg_postinst
}
