# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/astyle/astyle-1.24.ebuild,v 1.1 2010/09/24 15:13:42 scarabeus Exp $

EAPI=3

inherit base java-pkg-opt-2 autotools

DESCRIPTION="Artistic Style is a reindenter and reformatter of C++, C and Java source code"
HOMEPAGE="http://astyle.sourceforge.net/"
SRC_URI="mirror://sourceforge/astyle/astyle_${PV}_linux.tar.gz
	http://gentoo.ccss.cz/${PV}-autotools.patch.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="debug java"

DEPEND="java? ( >=virtual/jdk-1.6 )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	java-pkg-opt-2_src_prepare
	cd "${WORKDIR}"
	epatch "${PV}-autotools.patch"
	cd "${S}"

	eautoreconf
}

src_configure() {
	local myopts
	if use java; then
		myopts="--with-java-include-dir=${JAVA_HOME}/include/"
	fi

	econf \
		--disable-dependency-tracking \
		--htmldir=/usr/share/doc/${PF}/html/ \
		$(use_enable debug) \
		${myopts}
}
