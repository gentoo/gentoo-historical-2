# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/linux-docs/linux-docs-2.6.16.ebuild,v 1.3 2006/05/28 20:29:26 tcort Exp $

inherit toolchain-funcs

MY_P=linux-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Developer documentation generated from the Linux kernel"
HOMEPAGE="http://www.kernel.org/"
SRC_URI="mirror://kernel/pub/linux/kernel/v2.6/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"

IUSE="html"
DEPEND="app-text/docbook-sgml-utils
		app-text/xmlto
		sys-apps/sed"
RDEPEND=""

src_unpack() {
	unpack ${A}

	sed -i \
		-e "s:db2:docbook2:g" \
		-e "s:/usr/local/man:${D}/usr/share/man:g" \
		${S}/Documentation/DocBook/Makefile
}

src_compile() {
	local ARCH=$(tc-arch-kernel)
	unset KBUILD_OUTPUT

	make mandocs || die "make mandocs failed"

	if use html; then
		make htmldocs || die "make htmldocs failed"
	fi
}

src_install() {
	local file
	local ARCH=$(tc-arch-kernel)
	unset KBUILD_OUTPUT

	make installmandocs || die "make installmandocs failed"

	if use html; then
		for file in Documentation/DocBook/*.html; do
			dohtml -r ${file/\.html/}
		done
	fi
}
