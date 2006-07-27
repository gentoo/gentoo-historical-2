# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/jre/jre-1.4.2.ebuild,v 1.2 2006/07/27 15:16:29 cardoe Exp $

DESCRIPTION="Virtual for JRE"
HOMEPAGE="http://java.sun.com/"
SRC_URI=""

LICENSE="as-is"
SLOT="1.4"
KEYWORDS="amd64 ia64 ppc ppc64 ~s390 x86"
IUSE=""

DEPEND="|| (
		=virtual/jdk-1.4.2*
		=dev-java/blackdown-jre-1.4.2*
		=dev-java/kaffe-1.1*
		=dev-java/sun-jre-bin-1.4.2*
		=dev-java/ibm-jre-bin-1.4.2*
	)"
RDEPEND="${DEPEND}"
