# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kwifimanager/kwifimanager-3.5.10.ebuild,v 1.1 2008/09/14 00:00:13 carlo Exp $

KMNAME=kdenetwork
KMMODULE=wifi
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="KDE wifi (wireless network) gui"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="kdehiddenvisibility"

DEPEND="net-wireless/wireless-tools"
RDEPEND="${DEPEND}"

KMEXTRA="doc/kwifimanager"
