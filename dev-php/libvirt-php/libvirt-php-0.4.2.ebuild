# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/libvirt-php/libvirt-php-0.4.2.ebuild,v 1.1 2011/12/14 22:30:25 mabi Exp $

EAPI=3

PHP_EXT_NAME="libvirt-php"

inherit php-ext-source-r2 eutils

DESCRIPTION="PHP 5 bindings for libvirt."
HOMEPAGE="http://libvirt.org/php/"
SRC_URI="http://libvirt.org/sources/php/${P}.tar.gz"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="app-emulation/libvirt
	dev-libs/libxml2"
DEPEND="${DEPEND}
	doc? ( app-text/xhtml1 dev-libs/libxslt )"

src_unpack() {
	default
	# create the default modules directory to be able
	# to use the php-ext-source-r2 eclass to install
	ln -s src "${S}/modules"

	for slot in $(php_get_slots); do
		cp -r "${S}" "${WORKDIR}/${slot}"
	done
}

src_install() {
	php-ext-source-r2_src_install
	use doc && dohtml docs/* docs/graphics/*
}
