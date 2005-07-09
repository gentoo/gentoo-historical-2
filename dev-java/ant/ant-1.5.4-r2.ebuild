# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant/ant-1.5.4-r2.ebuild,v 1.7 2005/07/09 13:40:45 axxo Exp $

DESCRIPTION="Java-based build tool similar to 'make' that uses XML configuration files."
HOMEPAGE="http://ant.apache.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="x86 amd64 ppc sparc"
IUSE=""

DEPEND="=dev-java/ant-core-${PV}*"
RDEPEND="${DEPEND}"

