# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/phing/phing-2.1.0.ebuild,v 1.2 2006/01/01 16:56:16 sebastian Exp $

inherit php-pear-lib-r1

DESCRIPTION="PHP project build system based on Apache Ant."
HOMEPAGE="http://www.phing.info/"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
SRC_URI="http://phing.info/pear/phing-${PV}-pear.tgz"

need_php_by_category
