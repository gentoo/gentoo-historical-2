# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_watch/mod_watch-4.03-r2.ebuild,v 1.2 2007/11/25 13:37:21 hollow Exp $

inherit apache-module

KEYWORDS="ppc x86"

DESCRIPTION="Bandwidth graphing module for Apache2 with MRTG."
HOMEPAGE="http://www.snert.com/Software/mod_watch/"
SRC_URI="http://www.snert.com/Software/download/${PN}${PV/./}.tgz"
LICENSE="as-is"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}-4.3"

APACHE2_MOD_CONF="77_mod_watch"
APACHE2_MOD_DEFINE="WATCH"

DOCFILES="*.shtml CHANGES.TXT LICENSE.TXT Contrib/*.txt"

need_apache2

src_compile() {
	sed -i \
		-e "s:APXS=\\(.*\\):APXS=${APXS2} # \\1:" \
		-e "s:APACHECTL=\\(.*\\):APACHECTL=${APACHECTL2} # \\1:" \
		Makefile.dso || die "Path fixing failed"

	sed -i -e "s:/usr/local/sbin:/usr/sbin:" \
		apache2mrtg.pl || die "Path fixing failed"

	emake -f Makefile.dso build || die "emake failed"
}

src_install() {
	apache-module_src_install
	dosbin apache2mrtg.pl mod_watch.pl Contrib/mod_watch_list.pl
	keepdir /var/lib/${PN}
}
