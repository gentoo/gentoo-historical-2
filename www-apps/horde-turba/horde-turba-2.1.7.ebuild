# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/horde-turba/horde-turba-2.1.7.ebuild,v 1.4 2008/02/21 16:51:44 jer Exp $

HORDE_PHP_FEATURES="-o mysql mysqli odbc postgres ldap"
HORDE_MAJ="-h3"
inherit horde

DESCRIPTION="Turba is the Horde address book / contact management program"

KEYWORDS="alpha ~amd64 hppa ~ppc sparc x86"
IUSE="ldap"

DEPEND=""
RDEPEND=">=www-apps/horde-3
	ldap? ( dev-php/PEAR-Net_LDAP )"
