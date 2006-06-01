# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-misc/kdesdk-misc-3.5.0.ebuild,v 1.10 2006/06/01 10:21:34 tcort Exp $

KMNAME=kdesdk
KMNOMODULE="true"
KMNODOCS="true"
MAXKDEVER=3.5.2
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kdesdk-misc - Various files and utilities"
KEYWORDS="alpha amd64 ppc ppc64 ~sparc x86"
IUSE=""

KMEXTRA="kdepalettes/
	kdeaccounts-plugin/
	scheck/
	poxml/
	kprofilemethod/"