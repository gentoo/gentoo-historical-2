# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/java-virtuals/servlet-api/servlet-api-2.3.ebuild,v 1.7 2008/03/08 13:38:33 nelchael Exp $

inherit java-virtuals-2

DESCRIPTION="Virtual for servlet api"
HOMEPAGE="http://java.sun.com/products/servlet/"
SRC_URI=""

LICENSE="as-is"
SLOT="2.3"
KEYWORDS="~amd64 ~ia64 ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="=dev-java/tomcat-servlet-api-4*"
DEPEND=""

JAVA_VIRTUAL_PROVIDES="tomcat-servlet-api-2.3"
