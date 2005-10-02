# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mod_loopback/mod_loopback-2.01-r1.ebuild,v 1.4 2005/10/02 17:22:52 hansmi Exp $

inherit eutils apache-module

DESCRIPTION="A web client debugging tool (DSO) for Apache2"
HOMEPAGE="http://www.snert.com/Software/mod_loopback/index.shtml"
SRC_URI="http://www.snert.com/Software/download/${PN}201.tgz"

LICENSE="as-is"
KEYWORDS="ppc ppc64 x86"
IUSE=""
SLOT="2"

APACHE2_MOD_CONF="${PVR}/28_mod_loopback"
APACHE2_MOD_DEFINE="LOOPBACK"

S="${WORKDIR}/${PN}-2.1"

DOCFILES="CHANGES.TXT LICENSE.TXT"

need_apache2
