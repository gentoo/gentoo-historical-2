# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/gallery/gallery-2.3.1.ebuild,v 1.1 2010/12/09 09:02:31 radhermit Exp $

EAPI="2"

inherit webapp eutils depend.php confutils

DESCRIPTION="Web based (PHP Script) photo album viewer/creator"
HOMEPAGE="http://gallery.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-full.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="ffmpeg gd imagemagick mysql netpbm postgres raw sqlite unzip zip"

RDEPEND="raw? ( media-gfx/dcraw )
	ffmpeg? ( media-video/ffmpeg )
	imagemagick? ( || ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] ) )
	netpbm? ( media-libs/netpbm media-gfx/jhead )
	unzip? ( app-arch/unzip )
	zip? ( app-arch/zip )
	sqlite? ( dev-lang/php[pdo] )
	gd? ( || ( dev-lang/php[gd] dev-lang/php[gd-external] ) )
	mysql? ( || ( dev-lang/php[mysql] dev-lang/php[mysqli] ) )
	dev-lang/php[mysql?,session,postgres?,sqlite?]
	|| ( <dev-lang/php-5.3[pcre] >=dev-lang/php-5.3 )"

S=${WORKDIR}/${PN}2

need_httpd_cgi
need_php_httpd

pkg_setup() {
	webapp_pkg_setup
	confutils_require_any gd imagemagick netpbm
	confutils_require_any mysql postgres sqlite
}

src_install() {
	webapp_src_preinst

	dohtml README.html
	rm README.html LICENSE
	sed -i -e "/^LICENSE\>/d" -e "/^README\.html\>/d" MANIFEST

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_postinst_txt en "${FILESDIR}/postinstall-en2.txt"
	webapp_src_install
}

pkg_postinst() {
	elog "You are strongly encouraged to back up your database"
	elog "and the g2data directory, as upgrading may make"
	elog "irreversible changes to both."
	elog
	elog "g2data dir: cp -Rf /path/to/g2data/ /path/to/backup"
	elog "mysql: mysqldump --opt -u username -h hostname -p database > /path/to/backup.sql"
	elog "postgres: pg_dump -h hostname --format=t database > /path/to/backup.sql"
	webapp_pkg_postinst
}
