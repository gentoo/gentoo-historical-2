# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/ldapuserfolder/ldapuserfolder-2.4.ebuild,v 1.3 2004/11/09 17:00:14 lanius Exp $

inherit zproduct
PV_NEW=${PV/./_}

DESCRIPTION="LDAP User Authentication for Zope."
HOMEPAGE="http://www.dataflake.org/software/ldapuserfolder/"
SRC_URI="${HOMEPAGE}/${PN}_${PV}/LDAPUserFolder-${PV_NEW}.tgz"
LICENSE="ZPL"
KEYWORDS="x86 ~ppc"
RDEPEND=">=dev-python/python-ldap-2.0.0_pre05
	$RDEPEND"

ZPROD_LIST="LDAPUserFolder"
IUSE=""
