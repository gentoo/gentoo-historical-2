# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-antlr/ant-antlr-1.7.1-r1.ebuild,v 1.4 2009/04/05 14:10:50 maekke Exp $

EAPI=2

# just a runtime dependency
ANT_TASK_DEPNAME=""

inherit ant-tasks

KEYWORDS="amd64 ~ppc ppc64 x86 ~x86-fbsd"

DEPEND=""
RDEPEND=">=dev-java/antlr-2.7.5-r3:0[java]"

src_install() {
	ant-tasks_src_install
	java-pkg_register-dependency antlr
}
