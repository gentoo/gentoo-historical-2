# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libesmtp/libesmtp-1.0.3.ebuild,v 1.9 2006/01/27 14:27:31 slarti Exp $

inherit toolchain-funcs eutils

MY_P="${P}r1"
DESCRIPTION="libESMTP is a library that implements the client side of the SMTP protocol"
SRC_URI="http://www.stafford.uklinux.net/${PN}/${MY_P}.tar.bz2"
HOMEPAGE="http://www.stafford.uklinux.net/libesmtp/"
LICENSE="LGPL-2.1 GPL-2"

DEPEND=">=sys-devel/libtool-1.4.1
	>=sys-apps/sed-4
	ssl? ( >=dev-libs/openssl-0.9.6b )"

IUSE="ssl debug"
SLOT="0"
KEYWORDS="alpha ~amd64 ia64 ppc sparc x86"

S="${WORKDIR}/${MY_P}"

src_compile() {
	local myconf

	if [[ $(gcc-major-version) == 2 ]]; then
		myconf="${myconf} --disable-isoc"
	fi

	econf \
		--enable-all \
		--enable-threads \
		$(use_with ssl) \
		$(use_enable debug) \
		${myconf} || die "configure failed"

	if [[ $(gcc-major-version) == 3 ]] && [[ $(gcc-minor-version) == 3 ]]; then
		sed -i "s:-Wsign-promo::g" Makefile
	fi

	emake || die "emake failed"
}

src_install () {

	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS INSTALL ChangeLog NEWS Notes README TODO
	dohtml doc/api.xml

}
