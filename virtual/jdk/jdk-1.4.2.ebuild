# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/jdk/jdk-1.4.2.ebuild,v 1.7 2010/01/25 16:09:09 caster Exp $

DESCRIPTION="Virtual for JDK"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="1.4"
KEYWORDS="amd64 ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RDEPEND="|| (
		=dev-java/blackdown-jdk-1.4.2*
		=dev-java/sun-jdk-1.4.2*
		=dev-java/ibm-jdk-bin-1.4.2*
		=dev-java/jrockit-jdk-bin-1.4.2*
		=dev-java/apple-jdk-bin-1.4.2*
		=dev-java/kaffe-1.1*
	)"
DEPEND=""
