# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/polkit-kde/polkit-kde-0.95.1.ebuild,v 1.1 2010/02/08 22:16:56 alexxy Exp $

EAPI="2"

if [[ ${PV} = *9999* ]]; then
	KMNAME="extragear/base"
	KMMODULE="polkit-kde-1"
else
	KDE_LINGUAS="da en_GB et gl lt nl pt pt_BR sk sv uk zh_TW"
	MY_P="${P/kde/kde-1}"
	SRC_URI="mirror://kde/stable/apps/KDE4.x/admin/${MY_P}.tar.bz2"
fi
inherit kde4-base

DESCRIPTION="PolicyKit integration module for KDE."
HOMEPAGE="http://kde.org"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="
	>=sys-auth/polkit-qt-0.95.1
"
RDEPEND="${DEPEND}"

[[ ${PV} = *9999* ]] || S="${WORKDIR}/${MY_P}"
