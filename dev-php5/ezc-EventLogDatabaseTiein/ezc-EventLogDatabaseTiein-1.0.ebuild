# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/ezc-EventLogDatabaseTiein/ezc-EventLogDatabaseTiein-1.0.ebuild,v 1.7 2006/11/25 22:38:17 kloeri Exp $

inherit php-ezc

DESCRIPTION="This eZ component contains the database writer backend for the EventLog component."
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
RDEPEND="${RDEPEND}
	dev-php5/ezc-Database
	dev-php5/ezc-EventLog"
