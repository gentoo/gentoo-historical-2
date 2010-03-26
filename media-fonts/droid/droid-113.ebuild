# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/droid/droid-113.ebuild,v 1.1 2010/03/26 16:03:04 spatz Exp $

EAPI="2"

inherit font

MY_PN="${PN/d/D}"

# $PV is a build number, use fontforge to find it out. 113 was taken from:
# http://android.git.kernel.org/?p=platform/frameworks/base.git;a=tree;f=data/fonts;hb=HEAD
DESCRIPTION="Font family from Google's Android project"
HOMEPAGE="http://code.google.com/android/RELEASENOTES.html http://www.cosmix.org/software/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	mirror://gentoo/${MY_PN}SansMonoSlashed-112_p1.ttf.bz2
	mirror://gentoo/${MY_PN}SansMonoDotted-112_p1.ttf.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}
FONT_S=${WORKDIR}/${PN}
FONT_SUFFIX="ttf"

RDEPEND=""
DEPEND=""

src_unpack() {
	unpack ${A}

	mv "${WORKDIR}/${MY_PN}SansMonoSlashed-112_p1.ttf" \
		"${S}/${MY_PN}SansMonoSlashed.ttf"
	mv "${WORKDIR}/${MY_PN}SansMonoDotted-112_p1.ttf" \
		"${S}/${MY_PN}SansMonoDotted.ttf"
}
