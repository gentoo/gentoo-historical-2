# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/sud/sud-1.3.ebuild,v 1.7 2009/07/29 20:17:43 flameeyes Exp $

EAPI=2

inherit eutils flag-o-matic

DESCRIPTION="a daemon to execute processes with special (and customizable) privileges in a nosuid environment."
HOMEPAGE="http://s0ftpj.org/projects/sud/index.htm"
SRC_URI="http://s0ftpj.org/projects/sud/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

src_prepare() {
	sed -i -e \
		's:chmod 500 $(sbindir)/ilogin:chmod 500 $(DESTDIR)$(sbindir)/ilogin:' \
		"${S}"/login/Makefile.in || die "sed failed."
	sed -i -e \
		's:chmod 555 $(bindir)/suz:chmod 500 $(DESTDIR)$(bindir)/suz:' \
		"${S}"/su/Makefile.in || die "sed failed."
	sed -i -e \
		's:chmod 500 $(sbindir)/sud:chmod 500 $(DESTDIR)$(sbindir)/sud:' \
		"${S}"/sud/Makefile.in || die "sed failed."
}

src_configure() {
	append-flags -D_GNU_SOURCE
	default_src_configure
}

src_install() {
	# bug #277406
	emake -j1 DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog* README NEWS TODO
	doman ilogin.1 sud.1 suz.1
	insinto /etc
	doins miscs/sud.conf*
	newinitd "${FILESDIR}"/sud.rc6 sud
}
