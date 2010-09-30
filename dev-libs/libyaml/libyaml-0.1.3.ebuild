# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libyaml/libyaml-0.1.3.ebuild,v 1.3 2010/09/30 08:56:32 grobian Exp $

EAPI="2"

inherit eutils

MY_P="${P/lib}"

DESCRIPTION="YAML 1.1 parser and emitter written in C"
HOMEPAGE="http://pyyaml.org/wiki/LibYAML"
SRC_URI="http://pyyaml.org/download/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x86-solaris"
IUSE="doc examples test"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# conditionally remove tests
	if use test ; then
		sed -i -e 's: tests::g' Makefile*
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	use doc && dohtml -r doc/html/.
	dodoc README
	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins tests/example-*.c
	fi
}
