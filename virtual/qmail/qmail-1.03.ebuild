# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/qmail/qmail-1.03.ebuild,v 1.9 2010/01/11 11:12:59 ulm Exp $

DESCRIPTION="Virtual for qmail"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc s390 sh sparc x86"

IUSE=""
DEPEND=""

# netqmail-1.05 is a special case, because it's a vanilla
# qmail-1.03 but patched to fix some things.
# See its website, http://www.qmail.org/netqmail/

RDEPEND="|| (
	~mail-mta/netqmail-1.05
	~mail-mta/netqmail-1.06
	~mail-mta/mini-qmail-1.05
	~mail-mta/mini-qmail-1.06
	~mail-mta/qmail-ldap-${PV}
)"
