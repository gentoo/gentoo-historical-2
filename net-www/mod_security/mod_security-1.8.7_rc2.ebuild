# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mod_security/mod_security-1.8.7_rc2.ebuild,v 1.1 2005/03/01 01:50:39 beu Exp $

inherit eutils apache-module

MY_P=${P/_rc/RC}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Intrusion Detection System for apache"
HOMEPAGE="http://www.modsecurity.org"
SRC_URI="http://www.modsecurity.org/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"
IUSE="doc"

APXS1_ARGS="-S LIBEXECDIR=${S} -c ${S}/apache1/mod_security.c"
APACHE1_MOD_FILE="apache1/${PN}.so"
APACHE1_MOD_CONF="1.8.6/99_mod_security"
APACHE1_MOD_DEFINE="SECURITY"

APXS2_ARGS="-S LIBEXECDIR=${S} -c ${S}/apache2/mod_security.c"
APACHE2_MOD_FILE="apache2/.libs/${PN}.so"
APACHE2_MOD_CONF="1.8.6/99_mod_security"
APACHE2_MOD_DEFINE="SECURITY"

DOCFILES="CHANGES httpd.conf.* INSTALL LICENSE README"
useq doc && DOCFILES="${DOCFILES} modsecurity-manual.pdf"

need_apache
