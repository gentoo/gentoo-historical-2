# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/indent/indent-2.2.9-r4.ebuild,v 1.2 2007/08/06 19:39:16 uberlord Exp $

inherit eutils

DESCRIPTION="Indent program source files"
HOMEPAGE="http://www.gnu.org/software/indent/indent.html"
SRC_URI="mirror://gnu/indent/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="nls"

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND="nls? ( virtual/libintl )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-deb-gentoo.patch
	epatch "${FILESDIR}"/${PV}-malloc.patch
	epatch "${FILESDIR}"/${PV}-indent-off-segfault.patch # #125648

	# Update timestamp so it isn't regenerated #76610
	touch -r man/Makefile.am man/texinfo2man.c
}

src_compile() {
	# LINGUAS is used in aclocal.m4 #94837
	unset LINGUAS
	econf $(use_enable nls) || die
	emake || die "emake failed"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		htmldir="/usr/share/doc/${PF}/html" \
		install || die "make install failed"
	dodoc AUTHORS NEWS README*
}
