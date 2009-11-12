# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libical/libical-0.44.ebuild,v 1.1 2009/11/12 10:45:38 pva Exp $

EAPI="2"

DESCRIPTION="An implementation of basic iCAL protocols from citadel, previously known as aurore"
HOMEPAGE="http://freeassociation.sourceforge.net"
SRC_URI="mirror://sourceforge/freeassociation/files/${PN}/${P}/${P}.tar.gz"

LICENSE="|| ( MPL-1.1 LGPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}"

# https://sourceforge.net/tracker2/index.php?func=detail&aid=2196790&group_id=16077&atid=116077
# Upstream states that tests are supposed to fail (I hope sf updates archives
# and answer became visible):
# http://sourceforge.net/mailarchive/forum.php?thread_name=1257441040.20584.3431.camel%40tablet&forum_name=freeassociation-devel
RESTRICT="test"

src_prepare() {
	# Do not waste time building examples
	sed 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' \
		-i Makefile.am Makefile.in || die "sed failed"
}

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README TEST THANKS TODO \
		doc/{AddingOrModifyingComponents,UsingLibical}.txt || die "dodoc failed"

	if use examples; then
		rm examples/Makefile* examples/CMakeLists.txt
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
