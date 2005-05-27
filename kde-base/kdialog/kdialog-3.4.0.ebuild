# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdialog/kdialog-3.4.0.ebuild,v 1.5 2005/05/27 14:43:23 carlo Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDialog can be used to show nice dialog boxes from shell scripts"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""

RDEPEND="sys-apps/eject"

KMNODOCS=true

src_install() {
	kde-meta_src_install
	# see bug 89867
	cp ${FILESDIR}/kdeeject-${PV} ${T}/kdeeject
	into ${PREFIX}
	dobin ${T}/kdeeject
}