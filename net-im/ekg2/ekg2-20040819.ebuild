# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ekg2/ekg2-20040819.ebuild,v 1.4 2004/08/24 19:37:10 sekretarz Exp $

DESCRIPTION="Text based Instant Messenger client that supports many protocols like Jabber and Gadu-Gadu"
HOMEPAGE="http://www.ekg2.org/"
SRC_URI="http://dev.gentoo.org/~sekretarz/distfiles/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"

IUSE="gpm ssl spell jpeg nogg"

DEPEND=">=dev-libs/expat-1.95.6
	>=net-libs/gnutls-1.0.17
	gpm? ( >=sys-libs/gpm-1.20.1 )
	ssl? ( >=dev-libs/openssl-0.9.6m )
	jpeg? ( >=media-libs/jpeg-6b-r2 )
	spell? ( >=app-text/aspell-0.50.5 )
	!nogg? ( >=net-libs/libgadu-20040820 )"

#RDEPEND=""

S=${WORKDIR}/${P}

src_compile() {

	local ggconf=""
	if use nogg ; then
	    ggconf="--without-libgadu"
	else
	    ggconf="--with-libgadu"
	fi

	econf \
	    --with-pthread \
	    --with-libgadu \
	    ${ggconf} \
	    `use_with gpm gpm-mouse` \
	    `use_with ssl openssl` \
	    `use_with jpeg libjpeg` \
	    `use_with spell aspell` \
	     || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	einstall || die
}
