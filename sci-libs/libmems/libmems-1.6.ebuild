# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libmems/libmems-1.6.ebuild,v 1.3 2012/10/31 20:40:33 flameeyes Exp $

EAPI="2"

MY_TAG="mauve-2-2-0-release"
#ESVN_REPO_URI="https://mauve.svn.sourceforge.net/svnroot/mauve/libMems/tags/${MY_TAG}"

#inherit subversion autotools
inherit autotools

DESCRIPTION="Library for sci-biology/mauve"
HOMEPAGE="http://gel.ahabs.wisc.edu/mauve/"
#SRC_URI=""
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"
KEYWORDS="~amd64 ~x86"

CDEPEND=">=sci-libs/libgenome-1.3
	>=sci-libs/libmuscle-3.7
	dev-libs/boost"
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="${CDEPEND}"

#S="${WORKDIR}"

src_prepare() {
	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}" || die
}
