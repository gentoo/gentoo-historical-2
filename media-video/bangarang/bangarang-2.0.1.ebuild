# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/bangarang/bangarang-2.0.1.ebuild,v 1.1 2011/05/09 15:53:19 scarabeus Exp $

EAPI=4

KDE_MINIMAL="4.6"
KDE_LINGUAS="cs da de el es fi fr it lt nl pl pt_BR uk zh_CN"
KDE_SCM="git"
inherit kde4-base

DESCRIPTION="Media player for KDE utilizing Nepomuk for tagging"
HOMEPAGE="http://bangarangkde.wordpress.com"
EGIT_REPO_URI="git://gitorious.org/bangarang/bangarang.git"
[[ ${PV} == 9999 ]] || SRC_URI="http://opendesktop.org/CONTENT/content-files/113305-${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS=""
SLOT="4"
IUSE="debug"

RDEPEND="
	dev-libs/soprano
	$(add_kdebase_dep kdelibs 'semantic-desktop')
	$(add_kdebase_dep nepomuk)
	$(add_kdebase_dep kdemultimedia-kioslaves)
	media-libs/taglib
	media-libs/phonon
	x11-libs/qt-script
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

S=${WORKDIR}/bangarang-bangarang
