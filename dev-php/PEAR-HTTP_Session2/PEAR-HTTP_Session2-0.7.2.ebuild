# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-HTTP_Session2/PEAR-HTTP_Session2-0.7.2.ebuild,v 1.1 2009/08/22 22:50:30 beandog Exp $

inherit php-pear-r1 depend.php

DESCRIPTION="PHP5 Object-oriented interface to the session_* family functions.
Provides extra features such as database storage for session data using DB package."

LICENSE="BSD PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND=">=dev-lang/php-5.2.0
	!minimal? ( >=dev-php/PEAR-MDB2-2.4.1
			>=dev-php/PEAR-DB-1.7.11 )"
