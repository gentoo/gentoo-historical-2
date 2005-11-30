# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PECL-imagick/PECL-imagick-0.9.11.ebuild,v 1.1 2005/02/14 12:01:33 sebastian Exp $

PHP_EXT_ZENDEXT="no"
PHP_EXT_INI="yes"

inherit php-ext-pecl

IUSE=""
DESCRIPTION="PHP wrapper for the ImageMagick library."
HOMEPAGE="http://pecl.php.net/imagick"
SLOT="0"
LICENSE="PHP"
KEYWORDS="~x86 ~alpha ~sparc ppc"

DEPEND="${DEPEND}
		>=media-gfx/imagemagick-5.5.3"

src_install() {
	php-ext-pecl_src_install
	dodoc INSTALL
}
