# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/java-virtuals/jmx/jmx-1.0-r1.ebuild,v 1.6 2009/12/16 19:41:07 fauli Exp $

EAPI=1

inherit java-virtuals-2

DESCRIPTION="Virtual for Java Management Extensions (JMX)"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND="|| (
			virtual/jdk:1.6
			virtual/jdk:1.5
			dev-java/sun-jmx:0
		)
		>=dev-java/java-config-2.1.8
		"

JAVA_VIRTUAL_PROVIDES="sun-jmx"
JAVA_VIRTUAL_VM="=virtual/jre-1.6 =virtual/jre-1.5"
