# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/talloc/talloc-1.3.1.ebuild,v 1.1 2009/10/09 17:18:07 patrick Exp $

EAPI="2"

inherit confutils eutils

DESCRIPTION="talloc"
HOMEPAGE="http://talloc.samba.org/"
SRC_URI="http://samba.org/ftp/talloc/${P}.tar.gz"
LICENSE="GPL-3"
IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"

DEPEND="!net-fs/samba-libs[talloc]"
RDEPEND="${DEPEND}"

src_prepare() {

	./autogen.sh || die "autogen.sh failed"

	sed -i \
		-e 's|SHLD_FLAGS = @SHLD_FLAGS@|SHLD_FLAGS = @SHLD_FLAGS@ @LDFLAGS@|' \
		-e 's|CC = @CC@|CC = @CC@\
LDFLAGS = @LDFLAGS@|' \
		Makefile.in || die "sed failed"

}

src_configure() {

	econf \
		--sysconfdir=/etc/samba \
		--localstatedir=/var \
		--enable-largefile \
	|| die "econf failed"

}

src_compile() {

	emake showflags || die "emake showflags failed"
	emake shared-build || die "emake shared-build failed"

}

src_install() {

	emake install DESTDIR="${D}" || die "emake install failed"
	dolib.a sharedbuild/lib/libtalloc.a
	dolib.so sharedbuild/lib/libtalloc.so

}
