# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nessus/nessus-2.0.12.ebuild,v 1.7 2004/09/26 04:31:52 tgall Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="A remote security scanner for Linux"
HOMEPAGE="http://www.nessus.org/"
DEPEND=">=net-analyzer/nessus-libraries-${PV}
	>=net-analyzer/libnasl-${PV}
	>=net-analyzer/nessus-core-${PV}
	>=net-analyzer/nessus-plugins-${PV}"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha ~amd64 ppc64"
IUSE=""
