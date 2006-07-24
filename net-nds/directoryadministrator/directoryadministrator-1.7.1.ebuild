# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/directoryadministrator/directoryadministrator-1.7.1.ebuild,v 1.3 2006/07/24 02:00:03 tsunam Exp $

MY_PN="directory_administrator"
S="${WORKDIR}/${MY_PN}-${PV}"
DESCRIPTION="GUI to manage users and groups in a LDAP directory"
SRC_URI="http://diradmin.open-it.org/releases/${MY_PN}-${PV}.tar.gz"
HOMEPAGE="http://diradmin.open-it.org"
LICENSE="GPL-2"
DEPEND="gnome-base/gnome-libs
	net-nds/openldap
	=sys-libs/db-1.8*"
KEYWORDS="x86"
SLOT="0"
IUSE=""

src_install () {
	einstall || die

	dodoc AUTHORS ChangeLog CREDITS NEWS README TODO
	newdoc INSTALL README.setup
	dodoc doc/*
	docinto misc_docs
	dodoc doc/misc_docs/*
	docinto pam.d
	dodoc doc/pam.d/*
}
