# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jaxr-bin/sun-jaxr-bin-1.0.8.01.ebuild,v 1.1 2006/07/06 17:56:14 nelchael Exp $

JWSDP_VERSION="2.0"
JWSDP_DESC="Java API for XML Registries"

inherit java-wsdp

KEYWORDS="~x86"

DEPEND="${DEPEND}
	dev-java/sun-saaj-bin
	dev-java/sun-jaxb-bin"
