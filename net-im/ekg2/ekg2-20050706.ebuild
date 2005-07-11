# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ekg2/ekg2-20050706.ebuild,v 1.2 2005/07/11 22:10:57 swegener Exp $

DESCRIPTION="Text based Instant Messenger client that supports many protocols like Jabber and Gadu-Gadu"
HOMEPAGE="http://www.ekg2.org/"
SRC_URI="http://www.ekg2.org/archive/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86 ~ppc"

IUSE="gpm ssl spell jpeg nogg gsm python"

DEPEND=">=dev-libs/expat-1.95.6
	>=net-libs/gnutls-1.0.17
	gpm? ( >=sys-libs/gpm-1.20.1 )
	ssl? ( >=dev-libs/openssl-0.9.6m )
	jpeg? ( >=media-libs/jpeg-6b-r2 )
	spell? ( >=app-text/aspell-0.50.5 )
	!nogg? ( >=net-libs/libgadu-20040820 )
	gsm? ( >=media-sound/gsm-1.0.10 )
	python? ( >=dev-lang/python-2.3.3 )"

src_compile() {

	econf \
	    --with-pthread \
	    `use_with !nogg libgadu` \
	    `use_with gpm gpm-mouse` \
	    `use_with ssl openssl` \
	    `use_with jpeg libjpeg` \
	    `use_with spell aspell` \
	    `use_with gsm libgsm` \
	    `use_with python` \
	     || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	# Install plugins into proper directory
	if use amd64; then
		CONF_LIBDIR=$(getlib)/lib/ekg2/plugins
	fi

	einstall || die
	dodoc docs/*
}
