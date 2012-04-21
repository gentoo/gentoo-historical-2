# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/wicd-client-kde/wicd-client-kde-0.3.0.ebuild,v 1.2 2012/04/21 09:13:08 ago Exp $

EAPI=4

# Incompatible linguas handling
#KDE_LINGUAS="cs da de el en_GB es et fr hu it lt nb nds nl pa pl pt pt_BR ru sv
#uk zh_CN zh_TW"
EGIT_REPONAME="wicd-kde"
MY_P=${P/-client/}
KDE_SCM="git"
inherit kde4-base

DESCRIPTION="Wicd client built on the KDE Development Platform"
HOMEPAGE="http://kde-apps.org/content/show.php/Wicd+Client+KDE?content=132366"
[[ ${PV} == *9999 ]] || \
	SRC_URI="http://kde-apps.org/CONTENT/content-files/132366-${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="net-misc/wicd"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN/-client/}
