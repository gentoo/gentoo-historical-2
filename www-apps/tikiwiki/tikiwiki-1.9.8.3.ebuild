# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/tikiwiki/tikiwiki-1.9.8.3.ebuild,v 1.2 2007/10/30 19:20:40 dertobi123 Exp $

inherit webapp depend.php

DESCRIPTION="Full-featured Web Content Management System using PHP and Smarty Templates"
HOMEPAGE="http://tikiwiki.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
IUSE="mysql postgres graphviz"
KEYWORDS="~amd64 ppc ~sparc ~x86"

RDEPEND="virtual/httpd-cgi
	graphviz? ( media-gfx/graphviz )
"

need_php_httpd

pkg_setup () {
	webapp_pkg_setup
	use mysql && require_php_with_use mysql
	use postgres && require_php_with_use postgres
}

src_install() {
	webapp_src_preinst

	local DIR
	local DIRENTRY
	local DIRS="backups db dump files img/trackers img/wiki
		img/wiki_up modules/cache temp
		templates_c templates styles maps whelp mods
		lib/Galaxia/processes"

	# Ensure that directories exist, some don't.
	# (part of setup.sh)
	for DIR in ${DIRS}; do
		mkdir -p ${DIR}
	done

	# Remove the execute permission from the setup.sh script
	# and rename it.  Its actions have been incorporated here.
	chmod a-x setup.sh
	mv setup.sh setup.sh.done

	# Install the minimal doc (points to web page)
	#
	dodoc doc/readme.txt doc/htaccess doc/htaccess.readme INSTALL README

	# The bulk goes into htdocs
	# but don't copy INSTALL and README
	cp -pPR [[:lower:]]* "${D}"/"${MY_HTDOCSDIR}"

	# Recursively set server ownership to allow server to write
	# This is the rough equivalent of the setup.sh script
	# provided in the distribution.
	# Note: Cannot use xargs or find -exec here because
	# these don't work with shell functions.
	#
	webapp_serverowned "${MY_HTDOCSDIR}"
	for DIR in ${DIRS}; do
		find ${DIR} | while read DIRENTRY; do
			webapp_serverowned "${MY_HTDOCSDIR}"/${DIRENTRY}
		done
	done
	webapp_serverowned  "${MY_HTDOCSDIR}"/tiki-install.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
