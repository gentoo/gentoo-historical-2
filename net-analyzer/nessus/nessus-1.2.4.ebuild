# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nessus/nessus-1.2.4.ebuild,v 1.3 2002/12/09 04:33:08 manson Exp $

S=${WORKDIR}/${PN}

DESCRIPTION="A remote security scanner for Linux"
HOMEPAGE="http://www.nessus.org/"

DEPEND="=net-analyzer/nessus-libraries-${PV}
	=net-analyzer/libnasl-${PV}
	=net-analyzer/nessus-core-${PV}
	=net-analyzer/nessus-plugins-${PV}"
RDEPEND=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc -sparc "
