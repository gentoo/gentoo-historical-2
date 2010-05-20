# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/ezc-PersistentObject/ezc-PersistentObject-1.7.1.ebuild,v 1.1 2010/05/20 04:29:53 pva Exp $

EZC_BASE_MIN="1.8"
inherit php-ezc

DESCRIPTION="This eZ component allows you to store an arbitrary data structures to a fixed database table."
SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
IUSE=""

RDEPEND="${RDEPEND}
	>=dev-php5/ezc-Database-1.3"
