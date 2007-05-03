# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-trax/ant-trax-1.7.0.ebuild,v 1.7 2007/05/03 20:12:16 corsair Exp $

ANT_TASK_DEPNAME="xalan"

inherit ant-tasks

DESCRIPTION="Apache Ant .jar with optional tasks depending on XML transformer (xalan)"
KEYWORDS="~amd64 ~ia64 ~ppc ppc64 ~x86 ~x86-fbsd"

# it will build without it (ant manual says it's not needed since 1.4 JDK, dunno bout kaffe
# but contains a Xalan2Executor task which probably wouldn't work
DEPEND=">=dev-java/xalan-2.7.0-r2
	~dev-java/ant-junit-${PV}"
RDEPEND="${DEPEND}"

src_unpack() {
	ant-tasks_src_unpack all
	java-pkg_jar-from ant-junit
}
