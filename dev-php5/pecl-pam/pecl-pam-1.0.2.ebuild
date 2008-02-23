# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-pam/pecl-pam-1.0.2.ebuild,v 1.3 2008/02/23 18:13:48 swegener Exp $

PHP_EXT_NAME="pam"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"

inherit php-ext-pecl-r1 pam

KEYWORDS="~amd64 ~x86"

DESCRIPTION="This extension provides PAM (Pluggable Authentication Modules) integration."
LICENSE="PHP-2.02"
SLOT="0"
IUSE="debug"

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

need_php_by_category

src_compile() {
	my_conf="--with-pam=/usr $(use_enable debug)"
	php-ext-pecl-r1_src_compile
}

src_install() {
	pamd_mimic_system php auth account password
	php-ext-pecl-r1_src_install
}
