# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/horde-nag/horde-nag-2.0.ebuild,v 1.1 2004/12/24 08:00:11 vapier Exp $

HORDE_PHP_FEATURES="-o mysql odbc postgres ldap"
HORDE_MAJ="-h3"
inherit horde

DESCRIPTION="Nag is the Horde multiuser task list manager"

KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

DEPEND=""
RDEPEND=">=www-apps/horde-3"
