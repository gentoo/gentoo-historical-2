# Copyright 1999-2003 Gentoo Technologies, Inc.
# Released under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-php/jpgraph/jpgraph-1.12.2.ebuild,v 1.3 2003/08/04 23:43:56 stuart Exp $
#
# Based on the ebuild submitted by ??

DESCRIPTION="JpGraph is a fully OO graph drawing library for PHP."
HOMEPAGE="http://www.aditus.nu/jpgraph/"
SRC_URI="http://www.aditus.nu/jpgraph/downloads/${P}.tar.gz"

# QPL license for non-commercial use, regular commercial license available
LICENSE="QPL-1.0"

IUSE="truetype"

SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
DEPEND=""
RDEPEND="virtual/php
	     >=media-libs/libgd-1.8"

S="${WORKDIR}/${P}"
JPGRAPH_CACHE_DIR="/var/cache/jpgraph"

inherit php-lib

# setup defaults in case we don't have a web server installed

HTTPD_USER=root
HTTPD_GROUP=root

has_version "net-www/apache" && USE_APACHE=1 && inherit webapp-apache
[ -n $"{USE_APACHE}" ] && webapp-detect || NO_WEBSERVER=1

pkg_setup ()
{
	if [ "${NO_WEBSERVER}" = "1" ]; then
		ewarn "No webserver detected - ${JPGRAPH_CACHE_DIR} will be"
		ewarn "owned by ${HTTPD_USER} instead"
	else
		einfo "Configuring cache dir ${JPGRAPH_CACHE_DIR} for ${WEBAPP_SERVER}"
	fi
}

src_install ()
{
	einfo "Patching jpgraph.php"
	
	# patch 1:
	# make jpgraph use the correct group for file permissions

	sed -i "s|^DEFINE(\"CACHE_FILE_GROUP\",\"wwwadmin\");|DEFINE(\"CACHE_FILE_GROUP\", \"${HTTPD_GROUP}\";|" src/jpgraph.php

	# patch 2:
	# make jpgraph use the correct directory for caching

	sed -i "s|/tmp/jpgraph_cache/|${JPGRAPH_CACHE_DIR}/|g;" src/jpgraph.php

	# patch 3:
	# switch off the directory cache

	sed -i 's|^DEFINE("USE_CACHE",false);|if (!defined("USE_CACHE")) DEFINE("USE_CACHE", false);|' src/jpgraph.php

	# patch 4:
	# don't read the READ_CACHE if we're not creating any images in the
	# cache in the first place (doh)

	sed -i 's|DEFINE("READ_CACHE",true);|DEFINE("READ_CACHE", $USE_CACHE);|' src/jpgraph.php

	# install php files
	einfo "Building list of files to install"
	php-lib_src_install src `cd src ; find . -type f -print`

	# install documentation
	dodoc README src/Changelog
	dohtml -r docs/*

	# setup the cache dir
	# cachedir must be world-writable, because PHP/CLI doesn't run
	# as the apache user!

	keepdir "${JPGRAPH_CACHE_DIR}"
	fowners ${HTTPD_USER}.${HTTPD_GROUP} "${JPGRAPH_CACHE_DIR}"
	fperms 700 "${JPGRAPH_CACHE_DIR}"
}
