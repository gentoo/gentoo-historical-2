# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kapptemplate/kapptemplate-3.5_beta1.ebuild,v 1.4 2005/11/12 15:49:23 danarmak Exp $

KMNAME=kdesdk
MAXKDEVER=3.5.0_rc1
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KAppTemplate - A shell script that will create the necessary framework to develop various KDE applications"
KEYWORDS="~amd64 ~x86"
IUSE=""

