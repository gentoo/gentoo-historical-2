# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tor/tor-0.0.7.3.ebuild,v 1.4 2004/10/06 13:56:46 latexer Exp $

MY_P=${P/_rc/rc}
DESCRIPTION="Anonymizing overlay network for TCP"
HOMEPAGE="http://www.freehaven.net/tor/"
SRC_URI="http://www.freehaven.net/tor/dist/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc macos ppc-macos"
IUSE=""

DEPEND="dev-libs/openssl"
RDEPEND="!macos? ( !ppc-macos? ( net-misc/tsocks ) )"

S=${WORKDIR}/${MY_P}

src_install() {
	make DESTDIR=${D} install || die

	dodoc README ChangeLog AUTHORS \
		doc/{CLIENTS,FAQ,HACKING,TODO} \
		doc/{tor-design.tex,tor-spec.txt}
}
