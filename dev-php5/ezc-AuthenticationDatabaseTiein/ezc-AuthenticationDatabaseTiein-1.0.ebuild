# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/ezc-AuthenticationDatabaseTiein/ezc-AuthenticationDatabaseTiein-1.0.ebuild,v 1.3 2007/10/08 19:02:11 jokey Exp $

inherit php-ezc

DESCRIPTION="This eZ component contains database writer backend for the Authentication component."
SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
IUSE=""

RDEPEND="${RDEPEND}
	>=dev-php5/ezc-Authentication-1.0
	>=dev-php5/ezc-Database-1.3"
