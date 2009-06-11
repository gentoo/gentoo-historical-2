# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/coppermine/coppermine-1.4.24.ebuild,v 1.1 2009/06/11 18:42:09 a3li Exp $

inherit webapp versionator depend.php

DESCRIPTION="Web picture gallery written in PHP with a MySQL backend"
HOMEPAGE="http://coppermine.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/cpg${PV}.zip"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="imagemagick"

DEPEND="app-arch/unzip"
RDEPEND="imagemagick? ( media-gfx/imagemagick )"

UPSTREAM_VER=$(get_version_component_range 1-2)
S="${WORKDIR}"/cpg$(delete_version_separator 1 ${UPSTREAM_VER})x

need_httpd_cgi
need_php_httpd

pkg_setup() {
	webapp_pkg_setup
	require_php_with_use mysql
}

src_install() {
	webapp_src_preinst

	dodoc CHANGELOG README.txt
	dohtml docs/*
	rm -rf CHANGELOG README.txt COPYING docs/

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	dodir "${MY_HTDOCSDIR}"/albums/{userpics,edit}
	webapp_serverowned "${MY_HTDOCSDIR}"/albums{,/userpics,/edit}
	webapp_serverowned "${MY_HTDOCSDIR}"/include

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
