# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/horde-mnemo/horde-mnemo-1.1.1.ebuild,v 1.3 2004/03/29 01:37:44 zx Exp $

inherit horde

DESCRIPTION="Mnemo is the Horde note manager"

KEYWORDS="x86 ~ppc ~sparc ~alpha ~hppa"

DEPEND=""
RDEPEND=">=net-www/horde-2.2.5"

pkg_setup() {
	GREPBACKEND=`egrep 'sql|odbc|postgres|ldap' /var/db/pkg/dev-php/mod_php*/USE`
	if [ -z "${GREPBACKEND}" ] ; then
		eerror "Missing SQL or LDAP support in mod_php !"
		die "aborting..."
	fi
	horde_pkg_setup
}
