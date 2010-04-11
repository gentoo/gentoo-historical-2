# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/iniparser/iniparser-3.0b-r2.ebuild,v 1.2 2010/04/11 08:22:05 dev-zero Exp $

EAPI="2"

inherit eutils multilib

MY_P="${PN}${PV}"

DESCRIPTION="A free stand-alone ini file parsing library."
HOMEPAGE="http://ndevilla.free.fr/iniparser/"
SRC_URI="http://ndevilla.free.fr/iniparser/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="examples static-libs"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

# the tests are rather examples than tests, no point in running them
RESTRICT="test"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-fix-set-functions.patch" \
		"${FILESDIR}/${P}-cpp.patch" \
		"${FILESDIR}/${P}-makefile.patch"

	sed -i \
		-e "s|/usr/lib|/usr/$(get_libdir)|g" \
		Makefile || die "sed failed"
}

src_compile() {
	local targets="libiniparser.so"
	use static-libs && targets="${targets} libiniparser.a"

	emake ${targets} || die "emake failed"
}

src_install() {
	dolib libiniparser.so.0
	dosym libiniparser.so.0 /usr/$(get_libdir)/libiniparser.so

	use static-libs && dolib libiniparser.a

	insinto /usr/include
	doins src/*.h

	dodoc AUTHORS README
	dohtml html/*

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins test/*.c
	fi
}
