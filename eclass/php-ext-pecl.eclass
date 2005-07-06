# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/php-ext-pecl.eclass,v 1.5 2005/07/06 20:23:20 agriffis Exp $
#
# Author: Tal Peer <coredumb@gentoo.org>
#
# This eclass should be used by all dev-php/PECL-* ebuilds, as a uniform way of installing PECL extensions.
# For more information about PECL, see: http://pecl.php.net

[ -z "$PHP_EXT_PECL_PKG" ] && PHP_EXT_PECL_PKG=${PN/PECL-/}
PECL_PKG=$PHP_EXT_PECL_PKG
PECL_PKG_V=$PECL_PKG-$PV

[ -z "$PHP_EXT_NAME" ] && PHP_EXT_NAME=$PECL_PKG

inherit php-ext-source


EXPORT_FUNCTIONS src_compile src_install

# ---begin ebuild configurable settings

# Needs to be set if the filename is other than the package name
if [ -n "$PHP_EXT_PECL_FILENAME" ]; then
	FILENAME="${PHP_EXT_PECL_FILENAME}-${PV}.tgz"
else
	FILENAME="${PECL_PKG_V}.tgz"
fi

# ---end ebuild configurable settings

SRC_URI="http://pecl.php.net/get/${FILENAME}"
HOMEPAGE="http://pecl.php.net/${PECL_PKG}"
S=${WORKDIR}/${PECL_PKG_V}

php-ext-pecl_src_compile() {
	php-ext-source_src_compile
}

php-ext-pecl_src_install() {
	php-ext-source_src_install

	# Those two are always present
	dodoc $WORKDIR/package.xml CREDITS
}
