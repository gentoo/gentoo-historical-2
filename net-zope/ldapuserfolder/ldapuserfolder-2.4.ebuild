# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/ldapuserfolder/ldapuserfolder-2.4.ebuild,v 1.5 2006/01/27 02:37:05 vapier Exp $

inherit zproduct

PV_NEW=${PV/./_}
DESCRIPTION="LDAP User Authentication for Zope"
HOMEPAGE="http://www.dataflake.org/software/ldapuserfolder/"
SRC_URI="${HOMEPAGE}/${PN}_${PV}/LDAPUserFolder-${PV_NEW}.tgz"

LICENSE="ZPL"
KEYWORDS="~ppc ~sparc x86"

RDEPEND=">=dev-python/python-ldap-2.0.0_pre05"

ZPROD_LIST="LDAPUserFolder"
