# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/freeradius-dialupadmin/freeradius-dialupadmin-1.0.2.ebuild,v 1.2 2005/03/28 23:40:35 mrness Exp $

inherit webapp

MY_P=${P/-dialupadmin/}

DESCRIPTION="Web administration interface of freeradius server"
SRC_URI="ftp://ftp.freeradius.org/pub/radius/${MY_P}.tar.gz"
HOMEPAGE="http://www.freeradius.org/dialupadmin.html"

KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""
LICENSE="GPL-2"

DEPEND="virtual/php
	dev-lang/perl
	=net-dialup/freeradius-${PV}*
	sys-apps/findutils"

S="${WORKDIR}/${MY_P}/dialup_admin"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i -e 's:/usr/local:/usr:' \
		-e 's:/usr/etc/raddb:${general_raddb_dir}:' \
		-e 's:/usr/radiusd::' \
			conf/admin.conf
	sed -i -e 's:/usr/local:/usr:' bin/*

	#rename files .php3 -> .php
	(find . -iname '*.php3' | (
		local PHPFILE
		while read PHPFILE; do
			mv ${PHPFILE} ${PHPFILE/.php3/.php}
		done
	)) && \
	(find . -type f | xargs sed -i -e 's:[.]php3:.php:g') || \
		die "failed to replace php3 with php"
}

src_install() {
	webapp_src_preinst

	insinto ${MY_HTDOCSDIR}
	doins -r htdocs/*
	insinto ${MY_HOSTROOTDIR}
	doins -r conf html lib
	exeinto ${MY_HOSTROOTDIR}/bin
	doexe bin/[a-z]*

	insinto ${MY_SQLSCRIPTSDIR}
	doins sql/*

	dodoc Changelog bin/Changelog* README doc/*

	webapp_hook_script ${FILESDIR}/setrootpath

	cd ${D}${MY_HOSTROOTDIR}
	local CONFFILE
	for CONFFILE in conf/* ; do
		webapp_configfile ${MY_HOSTROOTDIR}/${CONFFILE}
		webapp_serverowned ${MY_HOSTROOTDIR}/${CONFFILE}
	done

	webapp_src_install
}
