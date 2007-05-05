# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant/ant-1.7.0.ebuild,v 1.8 2007/05/05 16:55:37 ticho Exp $

DESCRIPTION="Java-based build tool similar to 'make' that uses XML configuration files."
HOMEPAGE="http://ant.apache.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ppc64 x86 ~x86-fbsd"
IUSE=""

DEPEND="~dev-java/ant-core-${PV}
	~dev-java/ant-tasks-${PV}"
RDEPEND="${DEPEND}"
