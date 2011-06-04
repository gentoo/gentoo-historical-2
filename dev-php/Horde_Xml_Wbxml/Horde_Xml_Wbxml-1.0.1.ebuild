# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/Horde_Xml_Wbxml/Horde_Xml_Wbxml-1.0.1.ebuild,v 1.1 2011/06/04 20:01:10 a3li Exp $

EAPI=4

inherit php-pear-r1

KEYWORDS="~amd64"
SLOT="0"
DESCRIPTION="Horde_Xml_Wbxml provides an API for encoding and decoding WBXML documents used in SyncML and other wireless applications."
LICENSE="LGPL-2"
HOMEPAGE="http://www.horde.org/"
SRC_URI="http://pear.horde.org/${P}.tgz"

DEPEND=">=dev-lang/php-5.2.0
	>=dev-php/PEAR-PEAR-1.7.0
	=dev-php/Horde_Util-1*"
RDEPEND="${DEPEND}"
