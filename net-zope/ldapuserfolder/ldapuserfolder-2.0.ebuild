# Copyright 2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/ldapuserfolder/ldapuserfolder-2.0.ebuild,v 1.1 2003/03/30 06:49:42 kutsuya Exp $

inherit zproduct
PV_NEW=$(echo ${PV} |sed -e "s:\.:_:g")

DESCRIPTION="LDAP User Authentication for Zope."
HOMEPAGE="http://www.dataflake.org/software/ldapuserfolder/"
SRC_URI="${HOMEPAGE}LDAPUserFolder-${PV_NEW}.tgz"
LICENSE="ZPL"
KEYWORDS="~x86 ~ppc"
RDEPEND=">=dev-python/python-ldap-py21-2.0.0_pre05
	$RDEPEND"
IUSE=""

ZPROD_LIST="LDAPUserFolder"
