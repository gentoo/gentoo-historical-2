# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/clucene/clucene-0.9.20.ebuild,v 1.1 2007/10/02 21:04:55 philantrop Exp $

MY_P=${PN}-core-${PV}

DESCRIPTION="High-performance, full-featured text search engine based off of lucene in C++"
HOMEPAGE="http://clucene.sourceforge.net/"
SRC_URI="mirror://sourceforge/clucene/${MY_P}.tar.bz2"

LICENSE="|| ( Apache-2.0 LGPL-2.1 )"
SLOT="1"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE="debug doc threads"

DEPEND="doc? ( >=app-doc/doxygen-1.4.2 )"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf $(use_enable debug) \
		$(use_enable debug cnddebug) \
		$(use_enable threads multithreading) || die "econf failed"
	emake || die "emake failed"
	if use doc ; then
		emake doxygen || die "making docs failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"
	use doc && dohtml "${S}"/doc/html/*
}
