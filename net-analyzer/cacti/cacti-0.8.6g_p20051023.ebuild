# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/cacti/cacti-0.8.6g_p20051023.ebuild,v 1.5 2006/01/04 16:26:57 ramereth Exp $

inherit eutils webapp depend.apache

MY_P=${P/_p*/}

DESCRIPTION="Cacti is a complete frontend to rrdtool"
HOMEPAGE="http://www.cacti.net/"
# patches 
UPSTREAM_PATCHES="short_open_tag_parse_error graph_properties_zoom
script_server_snmp_auth mib_file_loading"
SRC_URI="http://www.cacti.net/downloads/${MY_P}.tar.gz"
for i in $UPSTREAM_PATCHES ; do
	SRC_URI="${SRC_URI} http://www.cacti.net/downloads/patches/${PV/_p*}/${i}.patch"
done

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc x86"
IUSE="snmp"

DEPEND=""

want_apache

# alpha doesn't have lighttpd keyworded yet
RDEPEND="!alpha? ( !apache? ( !apache2? ( www-servers/lighttpd ) ) )
	snmp? ( net-analyzer/net-snmp )
	net-analyzer/rrdtool
	!>=dev-db/mysql-5
	dev-db/mysql
	virtual/cron
	virtual/php
	virtual/httpd-php"

src_unpack() {
	unpack ${MY_P}.tar.gz ; mv ${MY_P} ${P}
	# patches
	for i in ${UPSTREAM_PATCHES} ; do
		EPATCH_OPTS="-p1 -d ${S} -N" epatch ${DISTDIR}/${i}.patch
	done ;
}

pkg_setup() {
	webapp_pkg_setup
	built_with_use virtual/php mysql || \
		die "php cli sapi must be compiled with USE=mysql"
	built_with_use virtual/httpd-php mysql || \
		die "php apache/cgi sapi must be compiled with USE=mysql"
}

src_compile() {
	einfo "Nothing to compile."
}

src_install() {
	webapp_src_preinst

	dodoc LICENSE
	rm LICENSE README

	dodoc docs/{CHANGELOG,CONTRIB,INSTALL,README,REQUIREMENTS,UPGRADE}
	rm -rf docs

	edos2unix `find -type f -name '*.php'`

	dodir ${MY_HTDOCSDIR}
	cp -r . ${D}${MY_HTDOCSDIR}

	webapp_configfile ${MY_HTDOCSDIR}/include/config.php
	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}

