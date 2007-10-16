# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libyaml/libyaml-0.0.1.ebuild,v 1.2 2007/10/16 00:52:43 sbriesen Exp $

inherit eutils

MY_P="${P/lib}"

DESCRIPTION="YAML 1.1 parser and emitter written in C"
HOMEPAGE="http://pyyaml.org/wiki/LibYAML"
SRC_URI="http://pyyaml.org/download/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"

IUSE="doc examples"
DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# conditionally remove tests
	if ! hasq test ${FEATURES}; then
		sed -i -e 's: tests::g' Makefile*
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	use doc && dohtml -r doc/html/.
	dodoc README
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins tests/example-*.c
	fi
}
