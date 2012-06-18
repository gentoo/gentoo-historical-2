# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ticpp/ticpp-9999.ebuild,v 1.2 2012/06/18 08:38:12 ago Exp $

EAPI=4

inherit subversion

ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk/"
MY_PV=cvs

DESCRIPTION="A completely new interface to TinyXML that uses MANY of the C++ strengths"
HOMEPAGE="http://code.google.com/p/ticpp/"
SRC_URI=""

LICENSE="GPL-2"
KEYWORDS="amd64 ~x86"
SLOT="0"
IUSE="debug doc"

DEPEND=">=dev-util/premake-4.3
	doc? ( app-doc/doxygen )"
RDEPEND=""

src_prepare() {
	premake4 gmake || die

	sed -i "s:\$(ARCH)::g" TiCPP.make || die
}

src_compile() {
	local myconf
	use !debug && myconf="config=release"
	emake ${myconf}

	if use doc ; then
		sed -i -e '/GENERATE_HTMLHELP/s:YES:NO:' dox || die
		doxygen dox || die
	fi
}

src_install () {
	insinto /usr/include/ticpp
	doins *.h

	if use debug ; then
		dolib lib/libticppd.a
	else
		dolib lib/libticpp.a
	fi

	dodoc {changes,readme,tutorial_gettingStarted,tutorial_ticpp}.txt

	use doc && dohtml -r docs/*
}
