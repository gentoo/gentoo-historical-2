# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/koffice-i18n.eclass,v 1.15 2002/10/27 11:09:12 danarmak Exp $

inherit kde
ECLASS=koffice-i18n
INHERITED="$INHERITED $ECLASS"

case $PV in
	1 | 1_* | 1.1*)
		need-kde 2.2
		SRC_PATH="kde/stable/koffice-${PV//_/-}/src/${PN}-${PV//_/-}.tar.bz2"
		;;
	# 1.2 prereleases
	1.2_*)
		need-kde 3
		SRC_PATH="kde/unstable/koffice-${PV//_/-}/src/${PN}-${PV//_/-}.tar.bz2"
		;;
	1.2)
		need-kde 3
		SRC_PATH="kde/stable/koffice-1.2/src/${P}.tar.bz2"
		;;
esac

SRC_URI="ftp://ftp.kde.org/pub/$SRC_PATH
	 ftp://ftp.fh-heilbronn.de/pub/mirrors/$SRC_PATH
	 ftp://ftp.sourceforge.net/pub/mirrors/$SRC_PATH"

S=${WORKDIR}/${PN}
DESCRIPTION="KOffice ${PV} - i18n: ${PN}"
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"
DEPEND="~app-office/koffice-${PV}"

set-enable-final
