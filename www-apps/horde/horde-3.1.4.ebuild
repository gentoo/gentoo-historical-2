# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/horde/horde-3.1.4.ebuild,v 1.1 2007/05/05 06:59:48 vapier Exp $

HORDE_PHP_FEATURES="session xml"

inherit horde

DESCRIPTION="Horde Application Framework"
HOMEPAGE="http://www.horde.org/"

KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="mysql"

DEPEND=""
RDEPEND="virtual/php
	>=sys-devel/gettext-0.10.40
	>=dev-libs/libxml2-2.4.21
	>=www-apps/horde-pear-1.3
	dev-php/PEAR-Log
	dev-php/PEAR-Mail_Mime
	mysql? ( dev-php/PEAR-DB )"

src_unpack() {
	horde_src_unpack
	cd "${S}"
	chmod 600 scripts/sql/create.*.sql #137510
}

pkg_postinst() {
	horde_pkg_postinst
	echo
	elog "Horde requires PHP to have:"
	elog "    ==> 'short_open_tag enabled = On'"
	elog "    ==> 'magic_quotes_runtime set = Off'"
	elog "    ==> 'file_uploads enabled = On'"
	elog "Please edit /etc/php/apache2-php4/php.ini"
}
