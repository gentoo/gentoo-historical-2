# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/jdk/jdk-1.6.0.ebuild,v 1.11 2009/07/05 05:10:29 ali_bush Exp $

DESCRIPTION="Virtual for JDK"
HOMEPAGE="http://java.sun.com/"
SRC_URI=""

LICENSE="as-is"
SLOT="1.6"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

# Keeps this and java-virtuals/jaf in sync
RDEPEND="|| (
		dev-java/icedtea6-bin
		=dev-java/sun-jdk-1.6.0*
		=dev-java/ibm-jdk-bin-1.6.0*
		=dev-java/diablo-jdk-1.6.0*
	)"
DEPEND=""
