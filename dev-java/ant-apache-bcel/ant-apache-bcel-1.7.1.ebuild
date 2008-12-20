# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-apache-bcel/ant-apache-bcel-1.7.1.ebuild,v 1.2 2008/12/20 16:44:12 nixnut Exp $

EAPI=1

ANT_TASK_DEPNAME="bcel"

inherit ant-tasks

KEYWORDS="~amd64 ~ia64 ppc ~ppc64 ~x86 ~x86-fbsd"

DEPEND="~dev-java/ant-nodeps-${PV}
	>=dev-java/bcel-5.1-r3:0"
RDEPEND="${DEPEND}"

src_unpack() {
	ant-tasks_src_unpack all
	java-pkg_jar-from ant-nodeps
}
