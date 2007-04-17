# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-imagick/pecl-imagick-0.9.13.ebuild,v 1.1 2007/04/17 21:10:15 chtekk Exp $

PHP_EXT_NAME="imagick"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-pecl-r1

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="PHP wrapper for the ImageMagick library."
LICENSE="PHP"
SLOT="0"
IUSE=""

DEPEND=">=media-gfx/imagemagick-6.2.0"
RDEPEND="${DEPEND}"

need_php_by_category
