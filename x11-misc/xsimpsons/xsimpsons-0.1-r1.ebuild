# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xsimpsons/xsimpsons-0.1-r1.ebuild,v 1.1 2008/10/15 19:01:10 flameeyes Exp $
inherit toolchain-funcs

DESCRIPTION="The Simpsons walking along the tops of your windows."
HOMEPAGE="http://netzverschmutzer.net/~sbeyer/programming/projects/?dir=extensions#xpenguins"
SRC_URI="http://netzverschmutzer.net/~sbeyer/programming/projects/extensions/xpenguins/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Replace Makefile, easier than patching it out!
	cat - > Makefile <<EOF
${PN}: xsimpsons.o toon.o
	\$(CC) \$(LDFLAGS) -o \$@ \$^ -lX11 -lXpm -lXext
EOF
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin xsimpsons || die "dobin failed"
	dodoc AUTHORS README
}
