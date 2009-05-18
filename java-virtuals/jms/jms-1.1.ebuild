# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/java-virtuals/jms/jms-1.1.ebuild,v 1.1 2009/05/18 19:38:05 betelgeuse Exp $

EAPI="1"

inherit java-virtuals-2

DESCRIPTION="Virtual for Java Message Service (JMS) API"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="|| (
			dev-java/glassfish-jms-api:0
			dev-java/sun-jms:0
		)
		"

JAVA_VIRTUAL_PROVIDES="glassfish-jms-api sun-jms"
