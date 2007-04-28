# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/tinyproxy/tinyproxy-1.6.3.ebuild,v 1.9 2007/04/28 16:51:44 swegener Exp $

DESCRIPTION="A lightweight HTTP/SSL proxy"
HOMEPAGE="http://tinyproxy.sourceforge.net/"
SRC_URI="mirror://sourceforge/tinyproxy/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ~sparc x86"
IUSE="socks5 transparent-proxy debug"

DEPEND="socks5? ( net-proxy/dante )"

src_compile() {
	econf \
		--enable-xtinyproxy \
		--enable-filter \
		--enable-tunnel \
		--enable-upstream \
		`use_enable transparent-proxy` \
		`use_enable debug` \
		`use_enable debug profiling` \
		`use_enable socks5 socks` \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	sed -i \
		-e 's:mkdir $(datadir)/tinyproxy:mkdir -p $(DESTDIR)$(datadir)/tinyproxy:' \
		Makefile
	make DESTDIR="${D}" install || die "install failed"

	dodoc AUTHORS ChangeLog NEWS README TODO
	mv "${D}/usr/share/tinyproxy" "${D}/usr/share/doc/${PF}/html"

	newinitd "${FILESDIR}/tinyproxy.rc" tinyproxy
}

pkg_postinst() {
	einfo "For filtering domains and URLs, enable filter option in the configuration file"
	einfo "and add them to the filter file (one domain or URL per line)."
}
