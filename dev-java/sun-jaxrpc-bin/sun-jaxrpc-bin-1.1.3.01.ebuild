# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jaxrpc-bin/sun-jaxrpc-bin-1.1.3.01.ebuild,v 1.4 2007/01/21 18:18:06 flameeyes Exp $

JWSDP_VERSION="2.0"
JWSDP_DESC="Java API for XML-based RPC"

inherit java-wsdp

KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"

DEPEND="${DEPEND}
	dev-java/sun-saaj-bin"
