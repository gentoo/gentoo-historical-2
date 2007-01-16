# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kbabel/kbabel-3.5.6.ebuild,v 1.1 2007/01/16 19:34:30 flameeyes Exp $

KMNAME=kdesdk
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KBabel - An advanced PO file editor"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="berkdb kdehiddenvisibility"

DEPEND="sys-devel/flex
	berkdb? ( || ( =sys-libs/db-4.3*
	               =sys-libs/db-4.2* ) )"

src_compile() {
	local myconf=""

	if use berkdb; then
		if has_version "=sys-libs/db-4.3*"; then
			myconf="${myconf} --with-berkeley-db --with-db-name=db-4.3
			        --with-db-include-dir=/usr/include/db4.3"
		elif has_version "=sys-libs/db-4.2*"; then
			myconf="${myconf} --with-berkeley-db --with-db-name=db-4.2
			        --with-db-include-dir=/usr/include/db4.2"
		fi
	else
		myconf="${myconf} --without-berkeley-db"
	fi

	kde_src_compile
}
