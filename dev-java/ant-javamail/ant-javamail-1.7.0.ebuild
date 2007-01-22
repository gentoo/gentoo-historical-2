# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-javamail/ant-javamail-1.7.0.ebuild,v 1.2 2007/01/22 10:31:15 flameeyes Exp $

ANT_TASK_DEPNAME="sun-javamail"

inherit ant-tasks

KEYWORDS="~x86 ~x86-fbsd"

DEPEND=">=dev-java/sun-javamail-1.4
	>=dev-java/sun-jaf-1.1"
RDEPEND="${DEPEND}"

src_unpack() {
	ant-tasks_src_unpack all
	java-pkg_jar-from sun-jaf
}
