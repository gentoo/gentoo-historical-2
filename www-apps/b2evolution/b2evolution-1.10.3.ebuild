# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/b2evolution/b2evolution-1.10.3.ebuild,v 1.2 2008/02/17 23:28:43 hollow Exp $

inherit webapp eutils depend.php

MY_EXT="2007-11-01"
MY_PV=${PV/_/-}

DESCRIPTION="Multilingual multiuser multi-blog engine"
HOMEPAGE="http://www.b2evolution.net"
SRC_URI="mirror://sourceforge/evocms/${PN}-${MY_PV}-${MY_EXT}.zip"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip"

need_php_httpd

S="${WORKDIR}/${PN}"

pkg_setup() {
	webapp_pkg_setup
	has_php
	if [[ ${PHP_VERSION} == "4" ]]; then
		require_php_with_use expat tokenizer mysql
	else
		require_php_with_use xml tokenizer mysql
	fi
}

src_install() {
	webapp_src_preinst

	insinto ${MY_HTDOCSDIR}
	doins -r blogs/*

	rm doc/*.*-*.html doc/*.src.html
	dohtml doc/*.html

	webapp_serverowned ${MY_HTDOCSDIR}
	webapp_serverowned ${MY_HTDOCSDIR}/conf/_basic_config.php
	webapp_configfile ${MY_HTDOCSDIR}/conf/_{basic_config,advanced,locales,formatting,admin,stats,application}.php

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}
