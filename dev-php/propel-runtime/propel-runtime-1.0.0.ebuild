# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/propel-runtime/propel-runtime-1.0.0.ebuild,v 1.1 2005/03/15 07:57:28 sebastian Exp $

inherit php-pear

DESCRIPTION="Object Persistence Layer for PHP 5 (Runtime)."
HOMEPAGE="http://propel.phpdb.org/wiki/"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
SRC_URI="http://propel.phpdb.org/pear/propel_runtime-${PV}.tgz"
RDEPEND=">=dev-php/php-5.0.0
	dev-php/creole"
S="${WORKDIR}/propel_runtime-${PV}"
