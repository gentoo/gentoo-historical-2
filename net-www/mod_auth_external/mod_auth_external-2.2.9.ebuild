# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mod_auth_external/mod_auth_external-2.2.9.ebuild,v 1.3 2005/06/27 16:25:41 blubb Exp $

inherit eutils apache-module

DESCRIPTION="An Apache2 authentication DSO using external programs"
HOMEPAGE="http://www.unixpapa.com/mod_auth_external.html"
SRC_URI="http://www.unixpapa.com/software/${P}.tar.gz"

DEPEND=""
LICENSE="Apache-1.1"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="2"

DOCFILES="AUTHENTICATORS CHANGES INSTALL INSTALL.HARDCODE README TODO"

APACHE2_MOD_CONF="2.2.7-r1/10_${PN}"
APACHE2_MOD_DEFINE="AUTH_EXTERNAL"

need_apache2
