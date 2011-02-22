# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ticpp/ticpp-9999.ebuild,v 1.1 2011/02/22 16:58:11 hwoarang Exp $

ESVN_REPO_URI="http://ticpp.googlecode.com/svn/trunk/"
inherit subversion

MY_PV=cvs
DESCRIPTION="A completely new interface to TinyXML that uses MANY of the C++ strengths"
HOMEPAGE="http://code.google.com/p/ticpp/"
SRC_URI=""

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="debug doc"

DEPEND="dev-util/premake
	doc? ( app-doc/doxygen sys-apps/sed )"
RDEPEND=""

S=${WORKDIR}/${PN}

src_compile() {
	local myconf

	premake --target gnu || die "creating Makefile failed"

	if use !debug ; then
		myconf="CONFIG=Release"
	fi

	emake ${myconf} || die "emake failed"

	if use doc ; then
		sed -i -e '/GENERATE_HTMLHELP/s:YES:NO:' dox || die "sed failed"
		doxygen dox || die "doxygen failed"
	fi
}

src_install () {
	insinto /usr/include/ticpp
	doins *.h || die "installing headers failed"

	if use debug ; then
		dolib libticppd.a || die "installing library failed"
	else
		dolib libticpp.a || die "installing library failed"
	fi

	dodoc {changes,readme,tutorial_gettingStarted,tutorial_ticpp}.txt || \
		die "dodoc failed"

	if use doc ; then
		dohtml -r docs/* || die "installing docs failed"
	fi
}
