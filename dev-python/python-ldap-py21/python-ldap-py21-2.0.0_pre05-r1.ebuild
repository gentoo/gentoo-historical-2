# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-ldap-py21/python-ldap-py21-2.0.0_pre05-r1.ebuild,v 1.9 2004/06/25 01:45:45 agriffis Exp $

PYTHON_SLOT_VERSION=2.1

inherit distutils
P_NEW="${PN%-py21}-${PV/_pre/pre}"
S=${WORKDIR}/${P_NEW}

DESCRIPTION="Various LDAP-related Python modules"
SRC_URI="mirror://sourceforge/python-ldap/${P_NEW}.tar.gz"
HOMEPAGE="http://python-ldap.sourceforge.net/"

DEPEND="${DEPEND}
	>=net-nds/openldap-2.0.11"
SLOT="0"
LICENSE="PYTHON"
KEYWORDS="x86 ~ppc"
IUSE=""

src_compile() {
	mv setup.cfg setup.cfg.orig
	sed -e "s|/usr/local/openldap2/lib|/usr/lib|" \
	    -e "s|/usr/local/openldap2/include|/usr/include|" \
		-e "s|libs = ldap lber|libs = ldap lber resolv|" \
		setup.cfg.orig > setup.cfg || die

	distutils_src_compile
}
