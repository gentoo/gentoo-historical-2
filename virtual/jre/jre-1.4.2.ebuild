# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/jre/jre-1.4.2.ebuild,v 1.6 2010/01/11 11:03:47 ulm Exp $

DESCRIPTION="Virtual for JRE"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="1.4"
KEYWORDS="amd64 ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RDEPEND="|| (
		=virtual/jdk-1.4.2*
		=dev-java/blackdown-jre-1.4.2*
		=dev-java/kaffe-1.1*
		=dev-java/sun-jre-bin-1.4.2*
		=dev-java/ibm-jre-bin-1.4.2*
	)"
DEPEND=""
