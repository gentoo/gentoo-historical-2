# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/simpleuserfolder/simpleuserfolder-0.9.0.ebuild,v 1.4 2006/01/27 02:46:25 vapier Exp $

inherit zproduct

MY_PN="SimpleUserFolder"
MY_PV="${PV//./-}"
MY_P="${MY_PN}-${MY_PV}"
DESCRIPTION="This is a User Folder replacement that will let you customize the source of users and roles for a particular folder or complete Zope instance"
HOMEPAGE="http://www.zope.org/Members/NIP/${MY_PN}"
SRC_URI="${HOMEPAGE}/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86"

S=${WORKDIR}

ZPROD_LIST="${MY_PN}"
MYDOC="${MYDOC} *.txt"

src_install() {
	zproduct_src_install
	# fix permissions on files
	DIR=${D}/usr/share/zproduct/${PF}
	find ${DIR} -exec chown zope:root \{} \;
	find ${DIR} -exec chmod 644 \{} \;
	find ${DIR} -type d -exec chmod +x \{} \;
}
