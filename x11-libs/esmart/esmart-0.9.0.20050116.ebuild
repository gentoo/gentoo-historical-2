# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/esmart/esmart-0.9.0.20050116.ebuild,v 1.1 2005/01/19 01:22:41 vapier Exp $

EHACKAUTOGEN=yes
inherit enlightenment flag-o-matic

DESCRIPTION="A collection of evas smart objects"
HOMEPAGE="http://www.enlightenment.org/pages/evas.html"

DEPEND=">=x11-libs/evas-1.0.0.20041226_pre13
	>=x11-libs/ecore-1.0.0.20041226_pre7
	>=media-libs/edje-0.5.0.20041226
	>=media-libs/epsilon-0.3.0.20041031
	>=media-libs/imlib2-1.2.0.20041226"
