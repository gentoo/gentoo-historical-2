# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/libupnp/libupnp-1.4.4.ebuild,v 1.2 2007/04/17 18:43:03 gurligebis Exp $

inherit eutils toolchain-funcs

DESCRIPTION="An Portable Open Source UPnP Development Kit"
HOMEPAGE="http://pupnp.sourceforge.net/"
SRC_URI="mirror://sourceforge/pupnp/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"

RDEPEND="!net-misc/upnp"

src_compile() {
	# w/o docdir to avoid sandbox violations	
	econf \
		$(use_enable debug) \
		--without-docdir \
		|| die "econf failed"
	emake || die "emake failed"

	# fix tests
	chmod +x ixml/test/test_document.sh
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dobin upnp/.libs/upnp_tv_{ctrlpt,device}
	dodoc NEWS README ChangeLog
	dohtml upnp/doc/*.pdf
}

