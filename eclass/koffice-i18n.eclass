# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/koffice-i18n.eclass,v 1.19 2002/12/11 20:27:47 hannes Exp $

inherit kde
ECLASS=koffice-i18n
INHERITED="$INHERITED $ECLASS"

case $PV in
	1 | 1_* | 1.1*)
		need-kde 2.2
		SRC_PATH="stable/koffice-${PV//_/-}/src/${PN}-${PV//_/-}.tar.bz2"
		KEYWORDS="x86"
		;;
	# 1.2 prereleases
	1.2_*)
		need-kde 3
		SRC_PATH="unstable/koffice-${PV//_/-}/src/${PN}-${PV//_/-}.tar.bz2"
		KEYWORDS="x86 ppc"
		;;
	1.2|1.2.1)
		need-kde 3
		SRC_PATH="stable/koffice-${PV}/src/${P}.tar.bz2"
		KEYWORDS="x86 ppc"
		;;
esac

SRC_URI="mirror://kde/$SRC_PATH"

S=${WORKDIR}/${PN}
DESCRIPTION="KOffice ${PV} - i18n: ${PN}"
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2"
DEPEND="~app-office/koffice-${PV}"

