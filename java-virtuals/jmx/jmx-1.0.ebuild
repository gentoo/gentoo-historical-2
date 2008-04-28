# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/java-virtuals/jmx/jmx-1.0.ebuild,v 1.1 2008/04/28 01:31:59 betelgeuse Exp $

EAPI=1

inherit java-virtuals-2

DESCRIPTION="Virtual for Java Management Extensions (JMX)"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="|| (
			virtual/jdk:1.6
			virtual/jdk:1.5
			dev-java/sun-jmx:0
		)
		>=dev-java/java-config-2.1.6
		"

JAVA_VIRTUAL_PROVIDES="sun-jmx"
JAVA_VIRTUAL_VM="sun-jdk-1.6 ibm-jdk-bin-1.6 sun-jdk-1.5 ibm-jdk-bin-1.5"
JAVA_VIRTUAL_VM+=" jrockit-jdk-bin-1.5 diablo-jdk-1.5"
