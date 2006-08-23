# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/jre/jre-1.3.ebuild,v 1.3 2006/08/23 21:22:24 swegener Exp $

DESCRIPTION="Virtual for JRE"
HOMEPAGE="http://java.sun.com/"
SRC_URI=""

LICENSE="as-is"
SLOT="1.3"
KEYWORDS="~ppc x86"
IUSE=""

RDEPEND="|| (
		=virtual/jdk-1.3*
		=dev-java/blackdown-jre-1.3*
		=dev-java/compaq-jre-1.3*
	)"
DEPEND=""
