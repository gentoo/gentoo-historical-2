# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mod_scgi/mod_scgi-1.10.ebuild,v 1.1 2006/06/05 17:33:25 hollow Exp $

inherit eutils apache-module

DESCRIPTION="Apache module for a Replacement for the CGI protocol that is similar to FastCGI"
HOMEPAGE="http://www.mems-exchange.org/software/scgi/"
SRC_URI="http://www.mems-exchange.org/software/files/scgi/${P/mod_}.tar.gz"

LICENSE="CNRI"
KEYWORDS="~x86 ~ppc"
IUSE="apache2"
DEPEND="www-apps/scgi"
RDEPEND="${DEPEND}"
SLOT="0"

S=${WORKDIR}/${P/mod_}

APXS1_S="${S}/apache1"
APACHE1_MOD_FILE="${S}/apache1/${PN}.so"
APACHE1_MOD_CONF="1.2/20_mod_scgi"
APACHE1_MOD_DEFINE="SCGI"

APXS2_S="${S}/apache2"
APACHE2_MOD_FILE="${S}/apache2/.libs/${PN}.so"
APACHE2_MOD_CONF="1.2/20_mod_scgi"
APACHE2_MOD_DEFINE="SCGI"

need_apache

DOCFILES="PKG-INFO LICENSE.txt CHANGES"

if useq apache2; then
	DOCFILES="${DOCFILES} apache2/README"
else
	DOCFILES="${DOCFILES} apache1/README"
fi
