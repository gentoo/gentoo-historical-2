# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_macro/mod_macro-1.1.6.ebuild,v 1.4 2005/02/27 19:05:42 vericgar Exp $

inherit eutils apache-module

DESCRIPTION="An Apache2 DSO providing macros for the apache config file"
HOMEPAGE="http://www.coelho.net/mod_macro/"
SRC_URI="http://www.coelho.net/mod_macro/${P}.tar.bz2"

LICENSE="BSD"
KEYWORDS="~x86"
SLOT="0"
IUSE=""

APACHE2_MOD_CONF="27_${PN}"
APACHE2_MOD_DEFINE="MACRO"

DOCFILES="CHANGES INSTALL README mod_macro.html"

need_apache2

