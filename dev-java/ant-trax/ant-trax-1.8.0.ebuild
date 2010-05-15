# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-trax/ant-trax-1.8.0.ebuild,v 1.2 2010/05/15 20:23:42 caster Exp $

EAPI=1

ANT_TASK_DEPNAME=""

inherit ant-tasks

DESCRIPTION="Apache Ant .jar with optional tasks depending on XML transformer (xalan)"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND=""

# it seems that xslt task will try to use Xalan2TraceSupport from ant-apache-xalan2
# when xalan happens to be on ant's classpath, so it's safer to have ant-apache-xalan2 there
# we need PDEPEND and register-optional-dependency to break circular dependency
PDEPEND="~dev-java/ant-apache-xalan2-${PV}"

src_install() {
	ant-tasks_src_install
	java-pkg_register-optional-dependency ant-apache-xalan2
}
