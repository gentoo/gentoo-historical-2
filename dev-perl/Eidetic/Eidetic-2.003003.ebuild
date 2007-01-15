# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Eidetic/Eidetic-2.003003.ebuild,v 1.10 2007/01/15 17:32:14 mcummings Exp $

inherit perl-module webapp eutils

DESCRIPTION="Templatized web-based database viewer, editor, indexer, etc"
HOMEPAGE="http://eidetic.sourceforge.net/"
SRC_URI="mirror://sourceforge/eidetic/${P}.tar.gz"

LICENSE="Artistic"
KEYWORDS="amd64 ~ia64 x86"
IUSE="mysql auth"

DEPEND="dev-lang/perl
		>=dev-perl/Config-Simple-4.1
		>=dev-perl/DBI-1.03
		>=virtual/perl-File-Temp-0.12
		>=virtual/perl-Digest-MD5-2.09
		>=virtual/perl-CGI-2.56
		virtual/perl-File-Spec
		>=dev-perl/Mail-Sender-0.8
		>=dev-perl/Sort-Tree-1.07
		>=dev-perl/Template-Toolkit-2.08
		dev-perl/Crypt-SmbHash
		mysql? ( virtual/mysql )
		auth? ( dev-perl/Apache-AuthTicket )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-destdir.patch
	epatch "${FILESDIR}"/${P}-sql.patch
}

src_install() {
	# explicit inherit function calls
	perl-module_src_install
	webapp_src_preinst

	# install .cgi file
	insinto ${MY_CGIBINDIR}
	doins cgi-bin/eidetic.cgi

	# install documentation
	dodoc doc/*

	# install db creation scripts
	if use mysql
	then
		insinto /usr/share/${P}/sql
		doins sql/*
		fperms a+x /usr/share/${P}/sql/load_db.sh
	fi

	#webapp stuff
	webapp_src_install
}

pkg_postinst() {
	if use mysql
	then
		einfo "The SQL scripts for ${PN} are located in /usr/share/${P}/sql."
		einfo "Use load_db.sh to create your initial database."
		einfo "Please note this must be ran as a user with database creation"
		einfo "priviliges."
		einfo ""
	fi
	if use auth
	then
		einfo "The README file contains important information on setting up"
		einfo "cookie authorization with Apache-AuthTicket.  Please be sure"
		einfo "to read it!"
	fi
}
