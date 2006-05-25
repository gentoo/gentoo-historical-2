# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-DB_DataObject/PEAR-DB_DataObject-1.8.4.ebuild,v 1.3 2006/05/25 22:52:32 chtekk Exp $

inherit php-pear-r1

DESCRIPTION="An SQL Builder, Object Interface to Database Tables."

LICENSE="PHP"
SLOT="0"
KEYWORDS="~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
RDEPEND=">=dev-php/PEAR-DB-1.7.6-r1
	>=dev-php/PEAR-Date-1.4.3-r1
	>=dev-php/PEAR-Validate-0.5.0-r1
	dev-php/PEAR-MDB2"
