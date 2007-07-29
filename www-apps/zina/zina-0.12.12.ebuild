# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/zina/zina-0.12.12.ebuild,v 1.3 2007/07/29 17:42:56 phreak Exp $

inherit webapp

DESCRIPTION="Zina (Zina Is Not Andromeda) is a digital audio streaming jukebox via a web interface."
HOMEPAGE="http://www.pancake.org/zina/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

RDEPEND="www-servers/apache
	virtual/httpd-php"

src_install() {
	webapp_src_preinst

	touch ${S}/zina.ini.php

	cp -R . ${D}${MY_HTDOCSDIR}

	webapp_configfile ${MY_HTDOCSDIR}/zina.ini.php

	# webapp-config currently does not support config-owned & server-owned at the
	# same time. Config protection is more important here.
	# - wrobel 05/12/23
	#webapp_serverowned ${MY_HTDOCSDIR}/zina.ini.php

	# Added cache directory for saving play lists
	# - wrobel 05/12/23
	keepdir ${MY_HTDOCSDIR}/_zina/cache
	webapp_serverowned ${MY_HTDOCSDIR}/_zina/cache

	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt
	webapp_src_install
}
