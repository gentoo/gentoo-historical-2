# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-nodeps/ant-nodeps-1.7.1.ebuild,v 1.2 2008/12/20 16:13:33 nixnut Exp $

inherit ant-tasks

DESCRIPTION="Apache Ant's optional tasks requiring no external deps"
KEYWORDS="~amd64 ~ia64 ppc ~ppc64 ~x86 ~x86-fbsd"

src_unpack() {
	ant-tasks_src_unpack base
	java-pkg_jar-from --build-only ant-core ant-launcher.jar
	java-pkg_filter-compiler jikes
}

src_compile() {
	eant jar-nodeps
}
