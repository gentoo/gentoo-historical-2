# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-apache-bcel/ant-apache-bcel-1.8.1.ebuild,v 1.3 2010/07/07 12:58:59 fauli Exp $

EAPI=1

ANT_TASK_DEPNAME="bcel"

inherit ant-tasks

KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="~dev-java/ant-nodeps-${PV}
	>=dev-java/bcel-5.1-r3:0"
RDEPEND="${DEPEND}"

src_unpack() {
	ant-tasks_src_unpack all
	java-pkg_jar-from ant-nodeps
}
