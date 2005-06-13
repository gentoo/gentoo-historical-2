# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxslt/libxslt-1.1.12.ebuild,v 1.9 2005/06/13 23:57:31 vapier Exp $

inherit libtool gnome.org eutils python

DESCRIPTION="XSLT libraries and tools"
HOMEPAGE="http://www.xmlsoft.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE="python crypt"

DEPEND=">=dev-libs/libxml2-2.6.15
	crypt? ( >=dev-libs/libgcrypt-1.1.92 )
	python? ( dev-lang/python )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# we still require the 1.1.8 patch for the .m4 file, to add
	# the CXXFLAGS defines <obz@gentoo.org>
	epatch "${FILESDIR}"/libxslt.m4-${PN}-1.1.8.patch
	epunt_cxx
	elibtoolize
}

src_compile() {
	econf \
		$(use_with python) \
		$(use_with crypt crypto) \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README NEWS TODO
}
